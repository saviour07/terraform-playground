resource "azurerm_servicebus_subscription" "sb_topic_subscription" {
  name                = "${var.sb_name}.${var.topic_name}"
  resource_group_name = var.rg_name
  namespace_name      = var.sb_name
  topic_name          = var.topic_name
  max_delivery_count  = var.topic_subscription_max_delivery_count
}
