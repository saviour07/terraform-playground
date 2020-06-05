/*
 * A Subscription has the following schema.
 * This Module expects a list of these objects to be
 * provided, even for a single Subscription.
 * 
 * This is to workaround Terraform Modules not supporting
 * the 'for_each' keyword *yet*.
 * 
subscription = 
{
  sub_name = string
  topic_name = string
  message_name = string
  max_delivery_count = number
  sql_filter = string
}
*/

locals {
  // The following line is the syntax for creating a map from the provided list.
  // Each iteration projects the current object, and a key/value pair can be created.
  // Such that "obj.property => obj" becomes "key = obj.property" and "value = obj".
  subs = { for sub in var.subscriptions : sub.sub_name => sub }
}

module "topics" {
    source = "../service-bus-topics"

    rg_name = var.rg_name
    sb_name = var.sb_name
    topics = var.topics
}

resource "azurerm_servicebus_subscription" "service_bus_topic_subscriptions" {

  for_each = local.subs

  name                = each.value.sub_name
  resource_group_name = var.rg_name
  namespace_name      = var.sb_name
  topic_name          = each.value.topic_name
  max_delivery_count  = each.value.max_delivery_count

  depends_on = [module.topics]
}

resource "azurerm_servicebus_subscription_rule" "service_bus_topic_subscription_sql_rules" {

  for_each = local.subs

  name                = each.value.sub_name
  resource_group_name = var.rg_name
  namespace_name      = var.sb_name
  topic_name          = each.value.topic_name
  subscription_name   = each.value.sub_name
  filter_type         = "SqlFilter"
  sql_filter          = each.value.sql_filter

  depends_on = [azurerm_servicebus_subscription.service_bus_topic_subscriptions]
}
