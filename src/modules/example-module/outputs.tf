resource "example_resource" "example" {
  name = var.example_name
  type = var.example_type
}

output "example_id" {
  value = example_resource.example.id
}

output "example_name" {
  value = example_resource.example.name
}
