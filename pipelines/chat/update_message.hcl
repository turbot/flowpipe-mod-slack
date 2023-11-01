// usage: flowpipe pipeline run update_message --pipeline-arg ts="1698385111.481129" --pipeline-arg message="hello world updated" --pipeline-arg channel=CEFG8LMN9
pipeline "update_message" {
  title       = "Update Message"
  description = "Update a message."

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

  param "ts" {
    type        = string
    description = "Timestamp of the message to be updated."
  }

  step "http" "update_message" {
    url    = "https://slack.com/api/chat.update"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel = param.channel
      text    = param.message
      ts      = param.ts
    })
  }

  output "message" {
    value       = step.http.update_message.response_body.message
    description = "Message details."
  }
}
