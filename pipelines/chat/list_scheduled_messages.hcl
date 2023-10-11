pipeline "list_scheduled_messages" {
  description = "Send a message to a channel."

  param "token" {
    type    = string
    default = var.token
  }

  step "http" "list_scheduled_messages" {
    title = "List scheduled messages"
    url    = "https://slack.com/api/chat.scheduledMessages.list"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

  }

  output "response_body" {
    value = step.http.list_scheduled_messages.response_body
  }
  output "response_headers" {
    value = step.http.list_scheduled_messages.response_headers
  }
  output "status_code" {
    value = step.http.list_scheduled_messages.status_code
  }

}
