// usage: flowpipe pipeline run archive_channel --pipeline-arg channel="C012ABCDXYZ"
pipeline "archive_channel" {
  title       = "Archive Channel"
  description = "Archive a Slack channel."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  step "http" "archive_channel" {
    url    = "https://slack.com/api/conversations.archive"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel = param.channel
    })
  }

  output "channel" {
    value       = step.http.archive_channel.response_body
    description = "Channel details."
  }
}
