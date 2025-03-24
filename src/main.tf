resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_ec2_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
