# terraform-playground
Playground area for experimenting with Terraform by producing modules which can be used across multiple projects without duplicating code when working with Infrastructure-As-Code.

## Modules
The terraform modules follow the recommended best practices from Hashicorp.
Each module is not just simply a wrapper around a single resource and each module is designed to be used in isolation (do not use modules from this repo within other modules of this repo).

### Code Reuse
The main aim of these Terraform modules is to reduce code duplication by allowing consumers to import the modules and provide the necessary variables in order to create the necessary infrastructure resources without those consumers having to define and maintain resources from within their own code.

Terraform modules are a way of grouping functionality together to provide a simple abstraction layer which will create the necessary infrastructure object(s).
By writing and using Modules, the root module which could potentially see a lot of code duplication can be reduced to the duplication of a single Module call e.g.

Rather than duplicating the following code multiple times in each root module when creating an Azure Service Bus:
```hcl
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
```hcl
module "service_bus" {
    source = "../modules/service-bus"

    sb_location = var.sb_location
    sb_prefix   = var.sb_prefix
    sb_name     = "${var.sb_name}${var.unique_id}"
    sb_sku      = var.sb_sku
    rg_name     = module.resource_group.rg_name
}
```

This also highlights how each module can be re-used to create multiple resources each with their own values as required.
