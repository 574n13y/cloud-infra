terraform {
  backend "s3" {
    versioning {
      enabled = true
    }
    dynamodb_table = "terraform-locks"
  }
}
