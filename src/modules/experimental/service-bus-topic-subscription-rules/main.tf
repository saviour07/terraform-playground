/*
 * A Rule has the following schema.
 * This Module expects a list of these objects to be
 * provided, even for a single Rule.
 * 
 * This is to workaround Terraform Modules not supporting
 * the 'for_each' keyword *yet*.
 * 
rule = 
{
  sub_name = string
  topic_name = string
  sql_filter = string
}
*/

resource "azurerm_servicebus_subscription_rule" "service_bus_topic_subscription_sql_rules" {

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
  for_each = { for rule in var.rules : rule.sub_name => rule }

  name                = each.value.sub_name
  resource_group_name = var.rg_name
  namespace_name      = var.sb_name
  topic_name          = each.value.topic_name
  subscription_name   = each.value.sub_name
  filter_type         = "SqlFilter"
  sql_filter          = each.value.sql_filter
}
