output "vpc_id" {
  value = module.networking.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
  description = "Public Subnet IDs"
}

output "bucket_name" {
    value = module.storage.bucket_name
    description = "Name of the S3 bucket"
}