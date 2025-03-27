terraform {
  backend "s3" {
    bucket = "stanley-cloud-infra"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    versioning {
      enabled = true
    }
    dynamodb_table = "terraform-locks"
  }
}
