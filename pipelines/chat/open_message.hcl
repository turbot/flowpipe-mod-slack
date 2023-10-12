pipeline "open_conversation" {
  description = "Opens or resumes a direct message or multi-person direct message."

  param "token" {
    type    = string
    default = var.token
  }

  param "users" {
    type = list(string)
  }

  step "http" "open_conversation" {
    title  = "Opens a direct message"
    url    = "https://slack.com/api/conversations.open"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      users = param.users
    })
  }

  output "response_body" {
    value = step.http.open_conversation.response_body
  }
  output "response_headers" {
    value = step.http.open_conversation.response_headers
  }
  output "status_code" {
    value = step.http.open_conversation.status_code
  }

}
