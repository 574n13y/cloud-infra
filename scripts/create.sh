#!/bin/bash

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./deploy.sh <environment>"
    exit 1
fi

cd ../
terraform init
terraform workspace select $ENVIRONMENT || terraform workspace new $ENVIRONMENT
terraform plan -var-file="environments/${ENVIRONMENT}/terraform.tfvars"
terraform apply -var-file="environments/${ENVIRONMENT}/terraform.tfvars" -auto-approve
