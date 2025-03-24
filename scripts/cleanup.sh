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
    echo "Usage: $0 -e <environment> [-f]"
    echo "  -e: Environment (dev|staging|prod)"
    echo "  -f: Force deletion without confirmation"
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
while getopts "e:f" opt; do
    case $opt in
        e) ENVIRONMENT="$OPTARG" ;;
        f) FORCE=true ;;
        *) usage ;;
    esac
done

# Validate environment
if [[ ! $ENVIRONMENT =~ ^(dev|staging|prod)$ ]]; then
    error "Invalid environment. Must be dev, staging, or prod"
fi

# Check if running in the correct directory
if [[ ! -f "terraform.tfvars" ]]; then
    error "Please run this script from the root of the terraform project"
fi

# Warning for production environment
if [[ $ENVIRONMENT == "prod" && $FORCE != true ]]; then
    warn "You are about to destroy PRODUCTION infrastructure!"
    read -p "Are you absolutely sure? Type 'yes' to confirm: " confirmation
    if [[ $confirmation != "yes" ]]; then
        error "Cleanup aborted"
    fi
fi

# Main cleanup process
cleanup() {
    log "Starting cleanup for $ENVIRONMENT environment..."

    # Select the correct workspace
    log "Switching to $ENVIRONMENT workspace..."
    terraform workspace select $ENVIRONMENT || error "Failed to switch workspace"

    # Initialize Terraform
    log "Initializing Terraform..."
    terraform init -backend-config="environments/${ENVIRONMENT}/backend.tfvars" || error "Terraform init failed"

    # Destroy infrastructure
    log "Destroying infrastructure..."
    if [[ $FORCE == true ]]; then
        terraform destroy -var-file="environments/${ENVIRONMENT}/terraform.tfvars" -auto-approve || error "Terraform destroy failed"
    else
        terraform destroy -var-file="environments/${ENVIRONMENT}/terraform.tfvars" || error "Terraform destroy failed"
    fi

    # Clean up local files
    log "Cleaning up local files..."
    rm -rf .terraform* terraform.tfstate* || warn "Some files could not be removed"

    log "Cleanup completed successfully!"
}

# Execute cleanup with error handling
cleanup || error "Cleanup failed"
