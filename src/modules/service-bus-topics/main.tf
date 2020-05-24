resource "azurerm_servicebus_topic" "sb_topic" {
  name                         = var.topic_name
  resource_group_name          = var.rg_name
  namespace_name               = var.sb_name
  enable_partitioning          = var.topic_enable_partitioning
  requires_duplicate_detection = var.topic_requires_duplicate_detection
}
