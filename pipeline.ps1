# Initialize Terraform
terraform fmt 
terraform init

# Check for errors during initialization
if ($LASTEXITCODE -ne 0) {
    Write-Error "Terraform initialization failed. Exiting..."
    exit $LASTEXITCODE
}

# Validate Terraform configuration
Write-Host "Validating Terraform configuration..."
terraform validate

# Check for errors during validation
if ($LASTEXITCODE -ne 0) {
    Write-Error "Terraform validation failed. Exiting..."
    exit $LASTEXITCODE
}

# Create a Terraform plan
Write-Host "Creating Terraform plan..."
terraform plan -out=tfplan

# Check for errors during planning
if ($LASTEXITCODE -ne 0) {
    Write-Error "Terraform planning failed. Exiting..."
    exit $LASTEXITCODE
}

# Apply the Terraform plan
Write-Host "Applying Terraform plan..."
terraform apply "tfplan"

# Check for errors during apply
if ($LASTEXITCODE -ne 0) {
    Write-Error "Terraform apply failed. Exiting..."
    exit $LASTEXITCODE
}

# Clean up the plan file
Remove-Item "tfplan"

Write-Host "Terraform apply completed successfully."