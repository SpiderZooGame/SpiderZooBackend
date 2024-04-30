# State bucket
terraform {
  backend "s3" {
    bucket  = "virtual-spider-zoo"
    key     = "virtual-spider-zoo/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}