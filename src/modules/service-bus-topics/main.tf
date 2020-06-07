/*
 * A Topic has the following schema.
 * This Module expects a list of these objects to be
 * provided, even for a single Topic.
 * 
 * This is to workaround Terraform Modules not supporting
 * the 'for_each' keyword *yet*.
 * 
topic =
{
    name = string
    enable_partitioning = bool
    requires_duplicate_detection = bool
    permissions = permission
}
permission =
{
    listen = bool
    send = bool
    manage = bool
}
*/

locals {
  // This is the syntax for creating a map from the provided list,
  // where each iteration projects the current object, and a key/value
  // pair can be created.
  // Where "obj.property => obj" is "key = obj.property, val = obj".
  service_bus_topics = { for topic in var.topics : topic.name => topic }
}

resource "azurerm_servicebus_topic" "service_bus_topics" {

  for_each = local.service_bus_topics

  name                         = each.value.name
  resource_group_name          = var.rg_name
  namespace_name               = var.sb_name
  enable_partitioning          = each.value.enable_partitioning
  requires_duplicate_detection = each.value.requires_duplicate_detection
}

resource "azurerm_servicebus_topic_authorization_rule" "auth_rule" {

  for_each = local.service_bus_topics

  name = "${each.value.name}Auth"
  resource_group_name = var.rg_name
  namespace_name = var.sb_name
  topic_name = each.value.name

  listen = each.value.permissions.listen
  send = each.value.permissions.send
  manage = each.value.permissions.manage

  depends_on =[azurerm_servicebus_topic.service_bus_topics]
}
