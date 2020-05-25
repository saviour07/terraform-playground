provider "azurerm" {
    version = "~> 2.1.0"
    features {}
}

module "resource_group" {
    source = "../modules/resource-groups"

    rg_location = var.rg_location
    rg_prefix   = var.rg_prefix
    rg_name     = var.rg_name
    rg_tags     = var.rg_tags
}

module "service_bus" {
    source = "../modules/service-bus"

    sb_location = var.sb_location
    sb_prefix   = var.sb_prefix
    sb_name     = var.sb_name
    sb_sku      = var.sb_sku
    rg_name     = module.resource_group.rg_name
}

module "internal_domain_topics" {
    source = "../modules/experimental/internal-domain-service-bus-topics-with-sub-rules"

    rg_name = module.resource_group.rg_name
    sb_name = module.service_bus.sb_name
}
