pipeline "list_scheduled_messages" {
  description = "Send a message to a channel."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  step "http" "list_scheduled_messages" {
    title  = "List scheduled messages"
    url    = "https://slack.com/api/chat.scheduledMessages.list"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

  }

}
