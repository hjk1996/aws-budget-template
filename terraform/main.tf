provider "aws" {
  region = local.region

  default_tags {
    tags = {
      TerraformManaged = true
    }
  }
}

terraform {
  backend "s3" {
    bucket = "khj-tfstates"
    key = "aws-budget-template"
    region = "ap-northeast-2"
    encrypt = true
  }
}


module "lambda" {
  source = "./modules/lambda"

  account_id = local.account_id
  region     = local.region
}

module "route53" {
  source = "./modules/route53"

  domain = var.domain
}

module "cloudfront" {
  source               = "./modules/cloudfront"
  artifact_bucket_name = local.artifact_bucket_name
}