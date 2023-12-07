pipeline "schedule_message" {
  title       = "Schedule Message"
  description = "Schedule a message to be sent to a channel."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "text" {
    type        = string
    description = "The formatted text to describe the content of the message."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  # Unix EPOCH timestamp of time in future to send the message. Help: https://www.epochconverter.com/
  param "post_at" {
    type        = number
    description = "Unix timestamp representing the future time the message should post to Slack."
  }

  param "unfurl_links" {
    type        = bool
    description = "Pass true to enable unfurling of primarily text-based content."
    optional    = true
  }

  param "unfurl_media" {
    type        = bool
    description = "Pass false to disable unfurling of media content."
    optional    = true
  }

  step "http" "schedule_message" {
    method = "post"
    url    = "https://slack.com/api/chat.scheduleMessage"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      for name, value in param : name => value if value != null && !contains(["cred"], name)
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

  output "message" {
    description = "Scheduled message details."
    value       = step.http.schedule_message.response_body.message
  }
}
