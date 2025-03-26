resource "aws_instance" "app_server" {
  ami           = "ami-0c55b72947225c21c" # Example Amazon Linux 2 AMI
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_ids]
}