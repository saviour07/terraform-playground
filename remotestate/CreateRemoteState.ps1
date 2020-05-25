param(
    [Parameter(Mandatory=$true)]
    [string]$environment
)

$originalDir = $PWD
cd $PSScriptRoot\$environment

terraform init
terraform plan -out=tfplan
terraform apply tfplan

$remoteStateResourceGroup = terraform output "resource_group_name"
$remoteStateAccount = terraform output "storage_account_name"
$remoteStateContainer = terraform output "storage_container_name"
$remoteStateAccountKey = terraform output "storage_account_key"

$context = "Machine"

[System.Environment]::SetEnvironmentVariable("TF_VARS_backend_rg_name", $remoteStateResourceGroup)
[System.Environment]::SetEnvironmentVariable("TF_VARS_backend_sa_name", $remoteStateAccount)
[System.Environment]::SetEnvironmentVariable("TF_VARS_backend_container_name", $remoteStateContainer)
[System.Environment]::SetEnvironmentVariable("TF_VARS_backend_sa_key", $remoteStateAccountKey)

cd $originalDir
