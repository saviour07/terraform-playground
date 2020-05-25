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
    messages = list(message)
    enable_partitioning = bool
    requires_duplicate_detection = bool
    max_delivery_count = number
}
message =
{
    name = string
    versions = list(version)
}
version =
{
    major = number
    minors = list(string)
}
*/

resource "azurerm_servicebus_topic" "service_bus_topics" {

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
  for_each = { for topic in var.topics : topic.name => topic }

  name                         = each.value.name
  resource_group_name          = var.rg_name
  namespace_name               = var.sb_name
  enable_partitioning          = each.value.enable_partitioning
  requires_duplicate_detection = each.value.requires_duplicate_detection
}
