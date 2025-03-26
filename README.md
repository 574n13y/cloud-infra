# Cloud Infrastructure Project

This project is designed to provision and manage cloud infrastructure using Terraform. It includes a modular structure to facilitate organization and reusability of code.

## Project Structure

```
cloud-infra-project
├── src
│   ├── main.tf                # Root configuration
│   ├── variables.tf           # Root variables
│   ├── outputs.tf             # Root outputs
│   ├── providers.tf           # Provider configurations
│   ├── backend.tf             # State management
│   └── modules
│       ├── networking         # VPC, Subnets, NAT Gateway
│       ├── security          # Security Groups, KMS Keys
│       ├── compute           # EC2, Auto Scaling Groups
│       └── storage           # S3 Buckets, Encryption
├── environments
│   ├── dev
│   │   ├──terraform.tfvars
│   │   └──  backend.tfvars
│   ├── staging
│   │   ├──terraform.tfvars
│   │   └──  backend.tfvars
│   └── prod
│       ├──terraform.tfvars
│       └──  backend.tfvars
├──  backend.tfvars
├── scripts
│   ├── deploy.sh             # Deployment script
│   └── cleanup.sh            # Resource cleanup script
├── .github
│   ├── workflows
│   │   ├── terraform.yml     # Main CI/CD workflow
│   │   └── cleanup.yml       # Cleanup workflow
│   ├── CODEOWNERS            # Code review assignments
│   └── pull_request_template.md
├── .gitignore
└── README.md
```

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- Git
- Bash shell (Git Bash for Windows)


## Setup Instructions

1. **Clone the Repository**
   ```powershell
   git clone https://github.com/574n13y/cloud-infra.git
   cd cloud-infra
   ```

2. **Configure AWS Credentials**
   ```powershell
   aws configure
   ```

3. **Select Environment**
   ```powershell
   terraform workspace new dev  # or staging/prod
   ```

4. **Initialize Infrastructure**
   ```powershell
   terraform init -backend-config="environments/dev/backend.tfvars"
   ```

5. **Validate Configuration**
   ```powershell
   terraform validate
   terraform fmt -recursive
   terraform plan -var-file="environments/dev/terraform.tfvars"
   ```

6. **Deploy Infrastructure**
   ```powershell
   terraform apply -var-file="environments/dev/terraform.tfvars"
   ```
   
## Environment-specific Deployments
```bash
# For dev environment
terraform workspace select dev
terraform plan -var-file="environments/dev/terraform.tfvars"

# For production
terraform workspace select prod
terraform plan -var-file="environments/prod/terraform.tfvars"
```

## Features

- **Networking Module**: VPC with public/private subnets, NAT Gateways
- **Security Module**: Preconfigured security groups, KMS encryption
- **Compute Module**: Auto Scaling Groups, Launch Templates
- **Storage Module**: S3 buckets with versioning and encryption


## Security Features
- VPC with private/public subnet separation
- Security groups with least privilege access
- KMS encryption for sensitive data
- S3 bucket versioning and encryption
- State file encryption and locking


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

...existing code...
## CI/CD Pipeline

### Workflows

1. **Terraform CI/CD**
   - Validates Terraform configurations
   - Plans infrastructure changes
   - Applies changes to environments
   
2. **Terraform Cleanup**
   - Manual workflow for infrastructure cleanup
   - Environment-specific destruction

### Pipeline Stages

1. **Validate**
   - Code formatting check
   - Terraform validation
   - Security scanning

2. **Plan**
   - Infrastructure planning
   - Cost estimation
   - Plan artifact creation

3. **Apply**
   - Environment-specific deployment
   - Post-deployment verification
   - Documentation updates

## Security Best Practices

1. **Infrastructure Security**
   - VPC with private/public subnet isolation
   - Security groups with least privilege access
   - KMS encryption for sensitive data
   - State file encryption and locking
     
2. **CI/CD Security**
   - Credentials stored in GitHub Secrets
   - Environment-specific approvals
   - Branch protection rules
   - Regular security scanning

3. **Monitoring**
   - CloudWatch monitoring enabled
   - AWS Config rules
   - Resource tagging for tracking

## Troubleshooting

1. **State Lock Issues**
   ```powershell
   terraform force-unlock <LOCK_ID>
   ```

2. **Plan Verification**
   ```powershell
   terraform show
   terraform plan -out=tfplan
   ```
3. **Common Issues**
   - Backend configuration errors
   - AWS credential issues
   - Resource conflicts

## Contributing

1. Fork the repository
2. Create a feature branch
   ```powershell
   git checkout -b feature/your-feature
   ```
3. Make changes and test
4. Submit PR with detailed description

## Scripts

### Deploy Script
```powershell
./scripts/deploy.sh -e dev            # Deploy to dev
./scripts/deploy.sh -e dev -p         # Plan only
./scripts/deploy.sh -e prod -f        # Force deploy
```

### Cleanup Script
```powershell
./scripts/cleanup.sh -e dev           # Cleanup dev
./scripts/cleanup.sh -e prod -f       # Force cleanup
```

## License

MIT License - See LICENSE file

## Support

- Open an issue for bugs
- Submit PR for improvements
- Contact maintainers for critical issues

## Authors
```
- Stanley - [@574n13y](https://github.com/574n13y)
```

## Usage Guidelines

- Use the `src/modules/example-module` directory to create reusable modules for your infrastructure components.
- Customize the input variables in `variables.tf` and `terraform.tfvars` as needed for your environment.
- Review the output values defined in `outputs.tf` to understand the resources created after applying the configuration.

