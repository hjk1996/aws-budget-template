provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      TerraformManaged = true
    }
  }
}


module "lambda" {
  source = "./modules/lambda"

  account_id = local.account_id
  region     = local.region
}

module "route53" {
  source = "./modules/route53"

  domain = local.domain
}