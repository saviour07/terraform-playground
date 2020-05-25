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
}
*/

resource "azurerm_servicebus_subscription" "service_bus_topic_subscriptions" {

  // The following line is two operations:
  // 1. for_each = /* map */
  // This is the syntax for iterating over the objects in the
  // provided map, where the key and values can be accessed
  // with the 'each' keyword e.g. each.key, each.value.property
  // 2. { for obj in list : obj.property => obj }
  // This is the syntax for creating a map from the provided list,
  // where each iteration projects the current object, and a key/value
  // pair can be created.
  // Where "obj.property => obj" is "key = obj.property, val = obj".
  for_each = { for sub in var.subscriptions : sub.sub_name => sub }

  name                = each.key
  resource_group_name = var.rg_name
  namespace_name      = var.sb_name
  topic_name          = each.value.topic_name
  max_delivery_count  = each.value.max_delivery_count
}
