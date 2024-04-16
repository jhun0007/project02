data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "project02-s3-tf-state"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
  }
}

