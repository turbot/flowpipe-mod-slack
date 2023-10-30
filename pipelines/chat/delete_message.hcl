// usage: flowpipe pipeline run delete_message --pipeline-arg ts="1698386187.334359" --pipeline-arg channel=CEFG8LMN9
pipeline "delete_message" {
  title       = "Delete Message"
  description = "Delete a message."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
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

  step "http" "delete_message" {
    url    = "https://slack.com/api/chat.delete"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel = param.channel
      ts      = param.ts
    })
  }

  output "message" {
    value       = step.http.delete_message.response_body
    description = "Message details."
  }
}
