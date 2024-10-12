


locals {
  region     = "ap-northeast-2"
  account_id = data.aws_caller_identity.current.account_id
  domain = "hjk-web.store"
}