pipeline "schedule_message" {
  description = "Send a message to a channel."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "message" {
    type        = string
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    description = "Channel containing the message to be updated."
    default     = var.channel
  }

  param "post_at" {
    type        = number // Unix EPOCH timestamp of time in future to send the message. Help: https://www.epochconverter.com/
    description = "Unix EPOCH timestamp of time in future to send the message."
  }

  param "unfurl_links" {
    type        = boolean
    description = "Pass true to enable unfurling of primarily text-based content."
    default     = false
  }

  param "unfurl_media" {
    type        = boolean
    description = "Pass false to disable unfurling of media content."
    default     = false
  }

  step "http" "schedule_message" {
    title  = "Scheduled a message"
    url    = "https://slack.com/api/chat.scheduleMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel      = "${param.channel}"
      text         = "${param.message}"
      post_at      = "${param.post_at}"
      unfurl_links = "${param.unfurl_links}"
      unfurl_media = "${param.unfurl_media}"
    })
  }

}
