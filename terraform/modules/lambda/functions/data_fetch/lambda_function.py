import os
import boto3


def lambda_handler(event, context):
    # 데이터 저장을 위한 DynamoDB 테이블 이름
    dynamodb = boto3.resource("dynamodb")
    table_name = os.getenv("table_name")
    return {
        "statusCode": 200,
        "body": table_name
    }