pipeline "delete_message" {
  description = "Update a message to a channel."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "ts" {
    type        = string
    description = "Timestamp of the message to be updated."
  }

  param "channel" {
    type        = string
    description = "Channel containing the message to be updated."
    default     = var.channel // TODO: MUST be an ID
  }

  step "http" "delete_message" {
    title  = "Delete message"
    url    = "https://slack.com/api/chat.delete"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel = param.channel
      ts      = param.ts
    })
  }

}
