output "instance_ip" {
  value = aws_instance.example.public_ip
}

output "instance_id" {
  value = aws_instance.example.id
}

output "db_endpoint" {
  value = aws_db_instance.example.endpoint
}
