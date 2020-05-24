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

module "inbox_topic" {
    source = "../modules/service-bus-topics"

    topic_name                         = var.inbox_topic_name
    topic_enable_partitioning          = var.inbox_topic_enable_partitioning
    topic_requires_duplicate_detection = var.inbox_topic_requires_duplicate_detection
    sb_name                            = module.service_bus.sb_name
    rg_name                            = module.resource_group.rg_name
}

module "inbox_topic_subscription" {
    source = "../modules/service-bus-topic-subscriptions"

    rg_name                               = module.resource_group.rg_name
    sb_name                               = module.service_bus.sb_name
    topic_name                            = module.inbox_topic.sb_topic_name
    topic_subscription_max_delivery_count = var.inbox_topic_subscription_max_delivery_count
}
