locals {
    internal_msg_props = {
        domain  = "X-MsgDomain"
        name    = "X-MsgName"
        version = "X-MsgVersion"
    }
    internal_msg_values = {
        domain   = "Internal"
        name     = "Else"
    }
    internal_topics = {
        "Internal" = {
            topic_name = "OneService"
            messages   = [
                {
                    name = "OneMsg",
                    versions = [ "1.0" ]
                }
            ]
        }
    }
    internal_subscriptions = flatten([
        for domain, topic in local.internal_topics : [
            for message in topic.messages : [
                for version in message.versions : {
                    domain_name = domain
                    topic_name = topic.topic_name
                    message_name = message.name
                    version = version
                    subscription_name = "${domain}.${topic.topic_name}.${message.name}.${version}"
                }
            ]
        ]
    ])
}

resource "azurerm_servicebus_topic" "internal_topic" {
  for_each = local.internal_topics

  name                         = each.value.topic_name
  resource_group_name          = azurerm_resource_group.rg.name
  namespace_name               = azurerm_servicebus_namespace.sb.name
  enable_partitioning          = true
  requires_duplicate_detection = true
}

resource "azurerm_servicebus_subscription" "internal_sub" {
  for_each = {
    for subscription in local.internal_subscriptions : subscription.subscription_name => subscription
  }

  name                = each.value.subscription_name
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  topic_name          = each.value.topic_name
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription_rule" "internalsub_rule" {
  for_each = {
    for subscription in local.internal_subscriptions : subscription.subscription_name => subscription
  }

  name                = each.value.subscription_name
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  topic_name          = each.value.topic_name
  subscription_name   = azurerm_servicebus_subscription.internal_sub[each.key].name
  filter_type         = "SqlFilter"
  sql_filter          = join(" AND ", [
    "${local.internal_msg_props["domain"]}='${local.internal_msg_values["domain"]}'",
    "${local.internal_msg_props["name"]}='${local.internal_msg_values["name"]}'",
    "${local.internal_msg_props["version"]}='${each.value.version}'"
  ])
}
