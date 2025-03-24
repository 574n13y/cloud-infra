output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.main.id
}

output "kms_key_id" {
  description = "ID of the KMS key"
  value       = aws_kms_key.main.id
}
