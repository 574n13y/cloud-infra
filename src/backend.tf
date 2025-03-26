terraform {
  backend "s3" {
    bucket         = "terraform-state-${var.environment}"
    key            = "terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
