locals {
  pandas_object_key = "layers/pandas/lambda_layer.zip"
}


#######################################################
// common
#######################################################

resource "aws_dynamodb_table" "price" {

  name         = "aws-resource-price-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "version"


  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "version"
    type = "S"
  }

}


resource "aws_ssm_parameter" "batch_target_resource" {
  name = "lambda-target-resources"
  type = "String"
  value = jsonencode([
    {
      resourceName = "AmazonEC2",
      productTypes = [
        {
          typeName = "Compute Instance"
          filters = {
            "operatingSystem" : ["Linux", "Windows"],
            "tenancy" : "Shared",
            "currentGeneration" : "Yes",
            "preInstalledSw" : "NA",
            "storage" : "EBS only",
            "processorArchitecture" : "64-bit",
            "capacitystatus" : "Used",
            "marketoption" : "OnDemand",
          },
          dropDuplicateSubset = ["instanceType", "pricePerUnit"]
        },
        {
          typeName = "Storage"
          filters = {
            "volumeApiName" : ["gp2", "gp3"]
          }
        },
        {
          typeName = "Load Balancer-Application"
          filters = {
            "usagetype" : "APN2-LoadBalancerUsage"
          }
        },
        {
          typeName = "Load Balancer-Network"
          filters = {
            "usagetype" : "APN2-LoadBalancerUsage"
          }
        },
        {
          typeName = "NAT Gateway"
          filters = {
            "unit" : "Hrs",
            "usagetype" : "APN2-NatGateway-Hours",
          }
        },
      ]

    },
    {
      resourceName = "AmazonRDS",
      productTypes = [
        {
          "typeName" = "Database Instance"
          filters = {
            "deploymentOption" : "Single-AZ",
            "locationType" : "AWS Region",
            "currentGeneration" : "Yes",
          },
          dropDuplicateSubset = ["instanceType", "pricePerUnit"]

        },

      ]

    },
    {
      resourceName = "AmazonEKS",
      productTypes = [
        {
          "typeName" = "Compute",
          filters = {
            "locationType" : "AWS Region",
            "usagetype" : "APN2-AmazonEKS-Hours:perCluster",
          }
        }
      ]

    },
    {
      resourceName = "AmazonS3",
      productTypes = [
        {
          "typeName" = "Storage"
          filters = {
            "storageClass" : [
              "General Purpose",
              "Infrequent Access",
              "Archive Instant Retrieval",
            ]
          }
        }
      ]

    },

    {
      resourceName = "AmazonElastiCache",
      productTypes = [
        {
          "typeName" = "Cache Instance"
          filters = {
            "locationType" : "AWS Region",
            "currentGeneration" : "Yes",
          }
        }
      ]
    },
  ])
  description = "Complex JSON configuration for my application"
}




#######################################################
// lambda layer
#######################################################

resource "aws_s3_bucket" "lambda_layer" {
  bucket = "budget-proejct-lambda-layer"
}

resource "null_resource" "pandas_layer_triger" {
  triggers = {
    file_hash = filebase64sha256("${path.module}/layer/lambda_layer.zip")
  }

  # 이 null_resource가 변경될 때마다 destroy -> recreate 동작
  lifecycle {
    create_before_destroy = true
  }
}


// 
resource "aws_s3_object" "pandas" {
  bucket = aws_s3_bucket.lambda_layer.bucket
  key    = local.pandas_object_key
  source = "${path.module}/layer/lambda_layer.zip"
  etag   = filemd5("${path.module}/layer/lambda_layer.zip")

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    null_resource.pandas_layer_triger
  ]
}

resource "aws_lambda_layer_version" "pandas" {
  layer_name          = "python-panda"
  description         = "python with pandas"
  compatible_runtimes = ["python3.11"] # 사용할 Python 런타임 버전에 맞게 수정

  s3_bucket = aws_s3_bucket.lambda_layer.bucket
  s3_key    = local.pandas_object_key

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_s3_bucket.lambda_layer,
    aws_s3_object.pandas,
    null_resource.pandas_layer_triger

  ]


}

#######################################################
// batch lambda funciton
#######################################################




resource "aws_iam_policy" "lambda_ssm_dynamodb_policy" {
  name = "lambda_ssm_dynamodb_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ],
        Resource = [
          "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${aws_ssm_parameter.batch_target_resource.name}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem"
        ],
        Resource = [
          "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${aws_dynamodb_table.price.name}"
        ]
      },

    ]
  })

  depends_on = [
    aws_dynamodb_table.price
  ]
}

resource "aws_iam_role_policy_attachment" "batch_2" {
  role       = aws_iam_role.batch.name
  policy_arn = aws_iam_policy.lambda_ssm_dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "batch_1" {
  role       = aws_iam_role.batch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



resource "aws_iam_role" "batch" {
  name               = "LambdaBudgetRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "archive_file" "batch" {
  output_path = "${path.module}/functions/batch/lambda_function.zip"
  source_file = "${path.module}/functions/batch/lambda_function.py"
  type        = "zip"
}

resource "aws_lambda_function" "batch" {
  function_name    = "batch-lambda-function"
  role             = aws_iam_role.batch.arn
  filename         = "${path.module}/functions/batch/lambda_function.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.batch.output_base64sha256
  timeout          = 300
  memory_size      = 1504


  environment {
    variables = {
      parameter_name = aws_ssm_parameter.batch_target_resource.name
      table_name     = aws_dynamodb_table.price.name
      region         = var.region

    }
  }

  layers = [
    aws_lambda_layer_version.pandas.arn
  ]

  depends_on = [
    data.archive_file.batch
  ]



}

#######################################################
// data fetch lambda
#######################################################
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "lambda_dynamodb_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:Scan",
        ],
        Resource = [
          "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${aws_dynamodb_table.price.name}"
        ]
      },

    ]
  })

  depends_on = [
    aws_dynamodb_table.price
  ]
}

resource "aws_iam_role_policy_attachment" "data_fetch_1" {
  role       = aws_iam_role.batch.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "data_fetch_2" {
  role       = aws_iam_role.batch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



resource "aws_iam_role" "data_fetch" {
  name               = "LambdaDataFetchRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "data_fetch_lambda" {
  output_path = "${path.module}/functions/data_fetch/lambda_function.zip"
  source_file = "${path.module}/functions/data_fetch/lambda_function.py"
  type        = "zip"
}



resource "aws_lambda_function" "date_fetch" {
  function_name    = "data-fetch-lambda-function"
  role             = aws_iam_role.data_fetch.arn
  filename         = "${path.module}/functions/data_fetch/lambda_function.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.data_fetch_lambda.output_base64sha256
  timeout          = 300


  environment {
    variables = {
      table_name     = aws_dynamodb_table.price.name
      region         = var.region
    }
  }


  depends_on = [
    data.archive_file.data_fetch_lambda
  ]



}