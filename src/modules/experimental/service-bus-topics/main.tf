resource "azurerm_servicebus_topic" "sb_topic" {

  for_each = var.topics

  name                         = each.key
  resource_group_name          = var.rg_name
  namespace_name               = var.sb_name
  enable_partitioning          = each.value.enable_partitioning
  requires_duplicate_detection = each.value.requires_duplicate_detection
}
