param(
    [Parameter(Mandatory=$true)]
    [string]$environment
)

$originalDir = $PWD
cd $PSScriptRoot\$environment

terraform init -force-copy
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

$mainConfig = Get-Content -Path "./main.tf"
if ($mainConfig -NotContains "terraform {") {
# A regex match for the backend block would be better,
# as the presence of a terraform block doesn't guarantee a backend is configured
$backendConfig =
"
terraform {
  backend ""azurerm"" {
    // These values need to be set by the terraform init
    // command using the -backend-config options.
    // resource_group_name = env:remoteStateResourceGroup
    // storage_account_name = env:remoteStateAccount
    // container_name = env:remoteStateContainer
    // access_key  = env:remoteStateAccountKey
    // key = terraform.tfstate
  }
  required_providers {
    azurerm = ""~> 2.1.0""
  }
}"

  Add-Content -Path "./main.tf" -Value $backendConfig

  terraform init -force-copy -backend-config="key=$environment.remote.tfstate" -backend-config="resource_group_name=$remoteStateResourceGroup" -backend-config="storage_account_name=$remoteStateAccount" -backend-config="container_name=$remoteStateContainer" -backend-config="access_key=$remoteStateAccountKey"

  Set-Content -Path "./main.tf" -Value $mainConfig
}

cd $originalDir
