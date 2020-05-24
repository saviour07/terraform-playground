rg_location = "ukwest"
rg_prefix = "my"
rg_name = "tfplayground"
rg_tags = {
    Environment = "Terraform Playground"
    Team = "Local"
}

sb_location = "ukwest"
sb_prefix = "my"
sb_name = "servicebus"
sb_sku = "standard"

inbox_topic_name = "inbox"
inbox_topic_enable_partitioning = true
inbox_topic_requires_duplicate_detection = true
inbox_topic_subscription_max_delivery_count = 1

topics = {
    "TopicOne" = {
        messages = [
            {
                name = "TopicOneMsgOne",
                versions = {
                    1 = [ "1.0" ]
                }
            }
        ],
        enable_partitioning = true,
        requires_duplicate_detection = true,
        max_delivery_count = 1
    },
    "TopicTwo" = {
        messages = [
            {
                name = "TopicTwoMsgOne",
                versions = {
                    1 = [ "1.0", "1.1" ]
                    2 = [ "2.0" ]
                }
            }
        ],
        enable_partitioning = true,
        requires_duplicate_detection = true,
        max_delivery_count = 1
    }
}
