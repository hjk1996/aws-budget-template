


locals {
  default_tag = "budget-project"
  region     = "ap-northeast-2"
  account_id = data.aws_caller_identity.current.account_id
  artifact_bucket_name = "${local.default_tag}-artifact-bucket"
}



