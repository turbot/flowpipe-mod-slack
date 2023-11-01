// usage: flowpipe pipeline run open_message --pipeline-arg 'users=["UB0AC1XYZ","UGACDC2XE"]'
pipeline "open_message" {
  title       = "Open Message"
  description = "Open or resume a direct message or multi-person direct message."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "users" {
    type        = list(string)
    description = "Comma separated lists of users. If only one user is included, this creates a 1:1 DM. The ordering of the users is preserved whenever a multi-person direct message is returned. Supply a channel when not supplying users."
  }

  step "http" "open_message" {
    url    = "https://slack.com/api/conversations.open"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      users = param.users
    })
  }

  output "message" {
    value       = step.http.open_message.response_body.channel
    description = "Message details."
  }
}
