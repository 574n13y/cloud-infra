# Cloud Infrastructure Project

This project is designed to provision and manage cloud infrastructure using Terraform. It includes a modular structure to facilitate organization and reusability of code.

## Project Structure

```
cloud-infra-project
├── src
│   ├── main.tf                # Main configuration file
│   ├── variables.tf           # Root variables
│   ├── outputs.tf             # Root outputs
│   ├── providers.tf           # Provider configurations
│   ├── backend.tf             # State backend configuration
│   └── modules
│       ├── networking
│       │   ├── main.tf        # VPC, Subnets, NAT Gateway
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── security
│       │   ├── main.tf        # Security Groups, KMS Keys
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── compute
│       │   ├── main.tf        # EC2, Auto Scaling Groups
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── storage
│           ├── main.tf        # S3 Buckets, Encryption
│           ├── variables.tf
│           └── outputs.tf
├── environments
│   ├── dev
│   │   └── terraform.tfvars
│   ├── staging
│   │   └── terraform.tfvars
│   └── prod
│       └── terraform.tfvars
├── scripts                    # Utility scripts
├── .gitignore
└── README.md
```

## Features

- **Networking Module**: VPC with public/private subnets, NAT Gateways
- **Security Module**: Preconfigured security groups, KMS encryption
- **Compute Module**: Auto Scaling Groups, Launch Templates
- **Storage Module**: S3 buckets with versioning and encryption


## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd cloud-infra-project
   ```

2. **Select Environment**
   ```bash
   terraform workspace new dev    # or staging/prod
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Configure Environment Variables**
   ```bash
   cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

5. **Plan the Infrastructure**
   ```bash
   terraform plan -var-file="environments/dev/terraform.tfvars"
   ```

6. **Apply the Configuration**
   ```bash
   terraform apply -var-file="environments/dev/terraform.tfvars"
   ```

## Security Features
- VPC with private/public subnet separation
- Security groups with least privilege access
- KMS encryption for sensitive data
- S3 bucket versioning and encryption
- State file encryption and locking

## Prerequisites
- AWS CLI configured
- Terraform >= 1.0.0
- AWS account with appropriate permissions

## Environment-specific Deployments
```bash
# For dev environment
terraform workspace select dev
terraform plan -var-file="environments/dev/terraform.tfvars"

# For production
terraform workspace select prod
terraform plan -var-file="environments/prod/terraform.tfvars"
```

## Security Best Practices
1. Use KMS encryption for sensitive data
2. Implement least privilege access
3. Enable versioning for S3 buckets
4. Use private subnets for sensitive resources
5. Implement proper tagging strategy

## Module Usage

### Networking Module
```hcl
module "networking" {
  source = "./modules/networking"
  vpc_cidr = "10.0.0.0/16"
  environment = "dev"
}
```

### Security Module
```hcl
module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
  environment = "dev"
}
```

## Monitoring and Maintenance
- Regular security updates
- Resource tagging for cost allocation
- State file backups
- Infrastructure documentation




## Usage Guidelines

- Use the `src/modules/example-module` directory to create reusable modules for your infrastructure components.
- Customize the input variables in `variables.tf` and `terraform.tfvars` as needed for your environment.
- Review the output values defined in `outputs.tf` to understand the resources created after applying the configuration.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.
1. Create a new branch
2. Make your changes
3. Submit a pull request

## License
MIT License
