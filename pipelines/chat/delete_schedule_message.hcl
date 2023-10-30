pipeline "delete_scheduled_message" {
  title       = "Delete Scheduled Message"
  description = "Delete a pending scheduled message from the queue."

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

  param "scheduled_message_id" {
    type        = string
    description = "scheduled_message_id returned from call to pipeline.schedule_message."
  }

  step "http" "delete_scheduled_message" {
    url    = "https://slack.com/api/chat.deleteScheduledMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel              = param.channel
      scheduled_message_id = param.scheduled_message_id
    })
  }

  output "delete_scheduled_message" {
    value       = step.http.delete_scheduled_message.response_body
    description = "Deletion details."
  }
}
