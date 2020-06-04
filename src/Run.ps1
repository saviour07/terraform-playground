param(
    [Parameter(Mandatory=$true)]
    [string]$environment
)

$originalDir = $PWD
cd $PSScriptRoot\$environment

terraform init -backend-config="key=$environment.terraform.tfstate" -backend-config="resource_group_name=$env:TF_VARS_backend_rg_name" -backend-config="storage_account_name=$env:TF_VARS_backend_sa_name" -backend-config="container_name=$env:TF_VARS_backend_container_name" -backend-config="access_key=$env:TF_VARS_backend_sa_key"

terraform plan -out=tfplan
terraform apply tfplan

$sbConnectionString = terraform output "sb_connection_string"

$context = "Machine"

[System.Environment]::SetEnvironmentVariable("ServiceBusConnectionString", $sbConnectionString)

cd $originalDir
