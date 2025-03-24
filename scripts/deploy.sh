#!/bin/bash

# Set error handling
set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo "Usage: $0 -e <environment> [-p] [-f]"
    echo "  -e: Environment (dev|staging|prod)"
    echo "  -p: Plan only (don't apply)"
    echo "  -f: Force apply without confirmation"
    exit 1
}

# Function to log messages
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%dT%H:%M:%S%z')]:${NC} $1"
}

# Function to log warnings
warn() {
    echo -e "${YELLOW}[WARNING]:${NC} $1"
}

# Function to log errors
error() {
    echo -e "${RED}[ERROR]:${NC} $1"
    exit 1
}

# Parse command line arguments
while getopts "e:pf" opt; do
    case $opt in
        e) ENVIRONMENT="$OPTARG" ;;
        p) PLAN_ONLY=true ;;
        f) FORCE=true ;;
        *) usage ;;
    esac
done

# Validate environment
if [[ ! $ENVIRONMENT =~ ^(dev|staging|prod)$ ]]; then
    error "Invalid environment. Must be dev, staging, or prod"
fi

# Check AWS credentials
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    error "AWS credentials not configured or invalid"
fi

# Main deployment function
deploy() {
    log "Starting deployment for $ENVIRONMENT environment..."

    # Create workspace if it doesn't exist
    terraform workspace new $ENVIRONMENT 2>/dev/null || terraform workspace select $ENVIRONMENT

    # Initialize Terraform
    log "Initializing Terraform..."
    terraform init -backend-config="environments/${ENVIRONMENT}/backend.tfvars" || error "Terraform init failed"

    # Format check
    log "Checking Terraform formatting..."
    terraform fmt -check -recursive || warn "Terraform formatting issues detected"

    # Validate configuration
    log "Validating Terraform configuration..."
    terraform validate || error "Terraform validation failed"

    # Create plan
    log "Creating Terraform plan..."
    terraform plan -var-file="environments/${ENVIRONMENT}/terraform.tfvars" -out=tfplan || error "Terraform plan failed"

    # Exit if plan only
    if [[ $PLAN_ONLY == true ]]; then
        log "Plan completed successfully. Exiting as requested."
        exit 0
    fi

    # Confirm deployment for production
    if [[ $ENVIRONMENT == "prod" && $FORCE != true ]]; then
        warn "You are about to deploy to PRODUCTION!"
        read -p "Are you absolutely sure? Type 'yes' to confirm: " confirmation
        if [[ $confirmation != "yes" ]]; then
            error "Deployment aborted"
        fi
    fi

    # Apply the plan
    log "Applying Terraform plan..."
    terraform apply tfplan || error "Terraform apply failed"

    # Clean up the plan file
    rm tfplan

    log "Deployment completed successfully!"
}

# Execute deployment with error handling
deploy || error "Deployment failed"

# Display outputs
if [[ $PLAN_ONLY != true ]]; then
    log "Terraform outputs:"
    terraform output
fi
