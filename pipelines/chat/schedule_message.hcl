pipeline "schedule_message" {
  title       = "Schedule Message"
  description = "Schedule a message to be sent to a channel."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "message" {
    type        = string
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    default     = var.channel
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  param "post_at" {
    type        = number // Unix EPOCH timestamp of time in future to send the message. Help: https://www.epochconverter.com/
    description = "Unix EPOCH timestamp of time in future to send the message."
  }

  param "unfurl_links" {
    type        = bool
    default     = true
    description = "Pass true to enable unfurling of primarily text-based content."
  }

  param "unfurl_media" {
    type        = bool
    default     = true
    description = "Pass false to disable unfurling of media content."
  }

  step "http" "schedule_message" {
    url    = "https://slack.com/api/chat.scheduleMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel      = param.channel
      text         = param.message
      post_at      = param.post_at
      unfurl_links = param.unfurl_links
      unfurl_media = param.unfurl_media
    })
  }

  output "schedule_message" {
    value       = step.http.schedule_message.response_body
    description = "Scheduled message details."
  }
}
