pipeline "delete_message" {
  description = "Update a message to a channel."

  param "token" {
    type    = string
    default = var.token
  }

  param "ts" {
    type = string
    // default = "Timestamp of the message to be updated."
  }

  param "channel" {
    type    = string
    default = var.channel // TODO: MUST be an ID
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

  output "response_body" {
    value = step.http.delete_message.response_body
  }
  output "response_headers" {
    value = step.http.delete_message.response_headers
  }
  output "status_code" {
    value = step.http.delete_message.status_code
  }

}
