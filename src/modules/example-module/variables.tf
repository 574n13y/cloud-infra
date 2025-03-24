variable "example_variable" {
  description = "An example variable for the example module"
  type        = string
  default     = "default_value"
}

variable "example_count" {
  description = "Number of examples to create"
  type        = number
  default     = 1
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}
