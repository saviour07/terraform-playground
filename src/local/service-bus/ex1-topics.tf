locals {
    ex1_msg_props = {
        domain  = "X-MsgDomain"
        name    = "X-MsgName"
        version = "X-MsgVersion"
    }
    ex1_msg_values = {
        domain   = "Ex1"
        name     = "ExOneMessages"
    }
    ex1_topics = [
        {
          topic_name = "ExOne"
          messages   = [
            {
                name = "ExOneMsg",
                versions = [ "1.0" ]
            },
            {
                name = "ExTwoMsg",
                versions = [ "1.0", "2.0" ]
            }
          ]
        },
        {
          topic_name = "ExTwo"
          messages = [
            {
              name = "ExOneMsg",
              versions = [ "1.0" ]
            },
            {
              name = "ExTwoMsg",
              versions = [ "1.0", "2.0" ]
            },
            {
              name = "ExThreeMsg",
              versions = [ "1.0", "2.0", "3.0" ]
            }
          ]
        }
    ]
    ex1_subscriptions = flatten([
        for topic in local.ex1_topics : [
            for message in topic.messages : [
                for version in message.versions : {
                    domain_name = local.ex1_msg_values["domain"]
                    topic_name = topic.topic_name
                    message_name = message.name
                    version = version
                    subscription_name = "${local.ex1_msg_values["domain"]}.${topic.topic_name}.${message.name}.${version}"
                }
            ]
        ]
    ])
}

resource "azurerm_servicebus_topic" "ex1_topic" {
    for_each = {
    for topic in local.ex1_topics : topic.topic_name => topic
  }

  name                         = each.value.topic_name
  resource_group_name          = azurerm_resource_group.rg.name
  namespace_name               = azurerm_servicebus_namespace.sb.name
  enable_partitioning          = true
  requires_duplicate_detection = true
}

resource "azurerm_servicebus_subscription" "ex1_sub" {
  for_each = {
    for subscription in local.ex1_subscriptions : subscription.subscription_name => subscription
  }

  name                = each.value.subscription_name
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  topic_name          = each.value.topic_name
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription_rule" "ex1sub_rule" {
  for_each = {
    for subscription in local.ex1_subscriptions : subscription.subscription_name => subscription
  }

  name                = each.value.subscription_name
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  topic_name          = each.value.topic_name
  subscription_name   = azurerm_servicebus_subscription.ex1_sub[each.key].name
  filter_type         = "SqlFilter"
  sql_filter          = join(" AND ", [
    "${local.ex1_msg_props["domain"]}='${local.ex1_msg_values["domain"]}'",
    "${local.ex1_msg_props["name"]}='${local.ex1_msg_values["name"]}'",
    "${local.ex1_msg_props["version"]}='${each.value.version}'"
  ])
}
