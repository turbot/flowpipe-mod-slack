// usage: flowpipe pipeline run create_channel --pipeline-arg channel="test-channel"
pipeline "create_channel" {
  title       = "Create Channel"
  description = "Create a Slack channel."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "channel" {
    type        = string
    description = "Name of the public or private channel to create."
  }

  param "is_private" {
    type        = bool
    default     = true
    description = "Create a private channel instead of a public one"
  }

  step "http" "create_channel" {
    url    = "https://slack.com/api/conversations.create"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      name       = param.channel
      is_private = param.is_private
    })
  }

  output "channel" {
    value       = step.http.create_channel.response_body
    description = "Channel details."
  }
}
