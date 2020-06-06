# terraform-playground
Playground area for experimenting with Terraform, Modules, and providing the easiest way in which teams of one or more people can collaborate when working with Infrastructure-As-Code.

To skip the lengthy description, details on how to run this project are [here](#build-&-run).

# Contents

1. [Structure](#structure)
2. [Scripts](#scripts)
3. [State](#state)
4. [Src](#src)

## Structure
The structure of how the files and folders are lay out is deliberate, in order to provide the best compromise between environment isolation and code reuse.

### Isolation
As part of any CI/CD pipeline there will always be several stages where code is deployed, for example:
* Local/Personal Development Environment
* Team Environment
* Continuous Integration Environment
* Staging Environment
* Production Environment
There can be more or less of these stages, varying depending on business specific needs.

When deploying infrastructure it is vital that the correct infrastructure objects are deployed to the correct environment.
Some environments may have special requirements such as a "dummy" external server in the Local Development Environment which responds with fake data to display in the UI; additional message bus subscriptions  in the Team Environment which allow events sent or received during integration tests to be validated; a Development account tier for Local Development versus a more expensive Enterprise worthy account tier in Production.
Terraform goes some way in doing this with the concept of workspaces and variable files (.tfvars), however this can be acheived in a more _obvious_ way to developers with a well-defined folder structure layout too.

The layout of the folder structure in this project is:

* root
    * stage-one
        - main.tf
        - outputs.tf
        - variables.tf
        - terraform.tfvars
    * stage-two
        - main.tf
        - outputs.tf
        - variables.tf
        - terraform.tfvars
    * modules
        * module-one
            - main.tf
            - outputs.tf
            - variables.tf
        * module-two
            - main.tf
            - outputs.tf
            - variables.tf

... and so on.

By structuring the code in this way, it provides a separation of each deployment stage with the root module for each of these directories defining everything that is specific to _that_ environment without needing to concern itself about any other environment's infrastructure needs.

### Code Reuse
When creating separate directories for each stage like this, it obviously comes with the downside of _some_ code duplication, however this can - and is here - limited through the use of Terraform Modules.

Modules are a way of grouping functionality together to provide a simple abstraction layer which will create the necessary infrastructure object(s).
By writing and using Modules, the root module which could potentially see a lot of code duplication can be reduced to the duplication of a single Module call e.g.

Rather than duplicating the following code multiple times in each root module when creating an Azure Service Bus:
```
resource "azurerm_servicebus_namespace" "sb" {
  name                = "${var.sb_prefix}${var.sb_name}"
  location            = var.sb_location
  resource_group_name = var.rg_name
  sku                 = var.sb_sku
}

resource "azurerm_servicebus_namespace_authorization_rule" "sbAuthRule" {
  name                = "sbAuth"
  namespace_name      = azurerm_servicebus_namespace.sb.name
  resource_group_name = var.rg_name

  listen = true
  send   = true
  manage = false
}
```

This code can be moved into a single Service Bus Module, allowing each environment's root module to simply call it like so:
```
module "service_bus" {
    source = "../modules/service-bus"

    sb_location = var.sb_location
    sb_prefix   = var.sb_prefix
    sb_name     = "${var.sb_name}${var.unique_id}"
    sb_sku      = var.sb_sku
    rg_name     = module.resource_group.rg_name
}
```

This also highlights how each stage is able to provide their own unique service bus name, location, and SKU depending on cost and need.
Modules can also be reused within other Modules, allowing for some very specific infrastructure to either be reused in multiple environments or only used in a single specific environment - all without creating a large, and often difficult-to-read root module.

## Scripts

To make deployment of these environments as simple as possible, it is a good idea to use scripts which allow developers to simply create or destroy their environment with as few commands as possible.

This project uses PowerShell scripts to do this, requiring just the environment which is to be deployed (there is also a "destroy" flag which can be provided that will teardown the specified environment).

These scripts are designed to perform all Terraform commands required in order to successfully deploy an environment, including writing any necessary Environment Variables (Windows-only for now!) which can be used in further Terraform commands.

While this can "hide" some of the Terraform commands from developers and make it appear to work like magic, the PowerShell scripts are written to be simple enough to understand for anyone with a little bit of PowerShell knowledge, and are by-design supposed to reduce the repetitive/multiple steps required into a single command.

## State

Describing Terraform state is something which is best covered by the [Terraform documentation](https://www.terraform.io/docs/state/index.html).

This project uses remote state with Azure as the remote backend, which has been deliberately separated into two parts:
1. Creating the remote backend for use with any project
2. Using the remote backend in the current project

This is because the Terraform which creates the remote backend required to store the state file remotely, will save that Terraform state file in the remote backend that the Terraform just created!

![Mind Blown](https://media.giphy.com/media/3oEduOKF6xcG94NaMw/giphy.gif)

This is acheived through the use of a PowerShell script, which will first deploy the remote backend infrastructure using a local state file, and then once complete it re-initialises Terraform with the backend information it just created so the local state file can be migrated to that remote backend.

Or:
1. Terraform initialises without a remote backend
- This creates a local state file
2. Terraform creates the infrastructure necessary to store a remote state file
- Information about the remote backend is stored in Environment Variables, such as the Resource Group Name, Storage Container Name, Access Key
3. Terraform is re-initialized with the remote backend it just created
- The Environment Variables from the previous step are passed to Terraform to do this
4. The local state file is migrated to the remote backend it has just created

After running the PowerShell script, a remote backend will have been created containing a state file for managing itself, and is available for any other project to also store a state file... such as the ones found in the Src directory.

## Src

The "src" directory is an example of how to put everything discussed in the previous sections into practice - isolating environments through directory structure, writing and reusing Modules to reduce code duplication, using scripts for ease of deployment and destruction, and leveraging remote state.

# Build & Run

To get started with this project, the following are required or recommended installs:
1. [Terraform](https://www.terraform.io/downloads.html) (Required)
2. [PowerShell](https://github.com/PowerShell/PowerShell/tree/master/docs/learning-powershell) (Required)
3. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
4. [.Net Core](https://docs.microsoft.com/en-us/dotnet/core/install/runtime?pivots=os-windows)

(*Note*: Some of the infrastructure deployed by these scripts may come at a physical cost to you depending on your Azure subscription type)

In a PowerShell terminal navigate to the "remotestate" directory and execute the following commands:

`az login`
- This will login to your Azure account

`.\CreateRemoteState.ps1 local`
- This will create the backend used to store Terraform state files remotely, store it's own state file remotely, and write some Environment Variables necessary to store other Terraform state files remotely

Navigate to the "src" directory and execute the following commands:

`.\Run.ps1 local`
- This will create the following resources in Azure:
    - Resource Group
    - Storage Account
    - Service Bus
        - Service Bus Topics with Subscriptions and SQL Filter Rules
- This will also use the backend created by the `CreateRemoteState.ps1` script to store the Terraform state file remotely.
