import sys
import os
import json
import datetime
import traceback
from decimal import Decimal
from uuid import uuid4

import boto3

from boto3.dynamodb.conditions import Attr
import urllib3

import pandas as pd


resource_file_template = "/tmp/{}_{}.json"

http = urllib3.PoolManager()


def download_resource_price_json(resource: str, region: str, date: str):
    request_template = "https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/{resource}/current/{region}/index.json"
    url = request_template.format(resource=resource, region=region)

    try:
        print(f"{url} 다운로드 중")
        response = http.request("GET", url)
        with open(resource_file_template.format(resource, date), "wb") as f:
            f.write(response.data)
        print(f"{resource} 다운로드 성공")
    except Exception as e:
        print(f"{resource} 다운로드 실패")
        traceback.print_exc()
        print(f"에러 메시지: {e}")
        sys.exit("함수 종료")


def download_prices(resources: list[str], region: str, date: str):
    for resource in resources:
        download_resource_price_json(resource, region, date)


def flatten_price(data: dict, product_family: str):
    result = []

    price_data = data["terms"]["OnDemand"]

    for sku, value in data["products"].items():
        new_row = value["attributes"]
        if value.get("productFamily") != product_family:
            continue

        # 딕셔너리의 첫번째 값만 가져옴
        price_data_row = next(iter(price_data[sku].values()))
        # 딕셔너리의 첫번째 값만 가져옴
        price_data_row = next(iter(price_data_row["priceDimensions"].values()))
        new_row["description"] = price_data_row["description"]
        new_row["pricePerUnit"] = price_data_row["pricePerUnit"]["USD"]
        new_row["unit"] = price_data_row["unit"]
        result.append(new_row)

    return pd.DataFrame(result)


def filter_df(df: pd.DataFrame, filters: dict):
    for column, value in filters.items():
        if column not in df.columns:
            raise KeyError(f"데이터프레임에 '{column}' 컬럼이 존재하지 않습니다.")
        if isinstance(value, list):
            df = df[df[column].isin(value)]
        else:
            df = df[df[column] == value]
    return df


def check_two_fields_match(table, field1_name, field1_value, field2_name, field2_value):
    # 스캔 실행: 두 개의 필드가 특정 값과 모두 일치하는 항목 찾기
    response = table.scan(
        FilterExpression=Attr(field1_name).eq(field1_value)
        & Attr(field2_name).eq(field2_value),
        ProjectionExpression=f"{field1_name}, {field2_name}",
    )

    # 조건에 맞는 항목이 하나라도 있는지 여부 반환
    items = response.get("Items", [])
    exists = len(items) > 0

    return exists


def lambda_handler(event, context):

    # SSM 파라미터 스토어에서 파라미터를 가져옴
    parameter_name = os.getenv("parameter_name")
    ssm = boto3.client("ssm")
    parameter = ssm.get_parameter(Name=parameter_name, WithDecryption=True)

    # List of dictionaries
    config = json.loads(parameter["Parameter"]["Value"])
    # 다운로드 받을 리소스 목록
    resources = [r["resourceName"] for r in config]
    today = datetime.date.today().isoformat()
    region = os.getenv("region")
    download_prices(resources, region, today)

    # 데이터 저장을 위한 DynamoDB 테이블 이름
    dynamodb = boto3.resource("dynamodb")
    table_name = os.getenv("table_name")
    table = dynamodb.Table(table_name)

    for r in config:
        resource_name = r["resourceName"]
        with open(resource_file_template.format(resource_name, today)) as f:
            data = json.load(f)

        version = data["version"]

        if check_two_fields_match(
            table, "servicecode", resource_name, "version", version
        ):
            print(f"{resource_name} 버전 {version}의 데이터는 이미 처리되었습니다.")
            continue

        for product_data in r["productTypes"]:  # List of dictionaries
            type_name = product_data["typeName"]
            df = flatten_price(data, type_name)

            if "filters" in product_data:
                df = filter_df(df, product_data["filters"])

            if "dropDuplicateSubset" in product_data:
                df = df.drop_duplicates(subset=product_data["dropDuplicateSubset"])

            if len(df) == 0:
                print(
                    f"{resource_name} 버전 {version}의 {product_data['productFamily']} 데이터가 없습니다."
                )
                continue

            df = df.drop_duplicates()
            df = df.reset_index(drop=True)

            with table.batch_writer() as batch:
                for index, row in df.iterrows():
                    row_dict = row.to_dict()

                    # float 타입의 데이터를 Decimal로 변환
                    row_dict = {k: v for k, v in row_dict.items() if pd.notna(v)}

                    for key in row_dict:
                        if isinstance(row_dict[key], float):
                            row_dict[key] = Decimal(row_dict[key])

                    row_dict["id"] = str(uuid4())
                    row_dict["resource"] = f"{resource_name}_{type_name}"
                    row_dict["version"] = version
                    # dynamodb에 저장하기 위해 가격 데이터를 Decimal로 변환
                    batch.put_item(Item=row_dict)
