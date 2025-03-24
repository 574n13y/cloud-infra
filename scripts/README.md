# Usage Instructions:

1. Basic Deployment:
   ```
   ./scripts/deploy.sh -e dev

   ./scripts/cleanup.sh -e dev
   ```
2. Plan Only (No Apply):
   ```
    ./scripts/deploy.sh -e dev -p
   
   ./scripts/cleanup.sh -e dev -f
   ```
4. Force Deploy (No Confirmation): ``` ./scripts/deploy.sh -e prod -f ```


### Features:

 - Environment validation
- AWS credentials check
- Terraform workspace management
- Format and validation checks
- Production deployment safeguards
- Colored output for better visibility
- Error handling and logging
- Plan file cleanup

### Windows Setup:
    ```
    # Add execution permission
    icacls "scripts\deploy.sh" /grant Everyone:RX
    ```

### Remember to:

- Test in lower environments first
- Review the plan output carefully
- Ensure AWS credentials are properly configured
- Keep the state files backed up
