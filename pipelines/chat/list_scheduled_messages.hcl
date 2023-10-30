pipeline "list_scheduled_messages" {
  title       = "List Scheduled Messages"
  description = "List of scheduled messages."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  step "http" "list_scheduled_messages" {
    url    = "https://slack.com/api/chat.scheduledMessages.list"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }
  }

  output "scheduled_messages" {
    value       = step.http.list_scheduled_messages.response_body
    description = "Scheduled messages details."
  }
}
