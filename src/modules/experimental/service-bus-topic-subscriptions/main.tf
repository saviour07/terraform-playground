resource "azurerm_servicebus_subscription" "sb_topic_subscription" {

  for_each = var.topics

  name                = "${var.sb_name}.${each.key}"
  resource_group_name = var.rg_name
  namespace_name      = var.sb_name
  topic_name          = each.key
  max_delivery_count  = each.value.max_delivery_count
}
