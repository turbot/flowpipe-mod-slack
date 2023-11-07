// usage: flowpipe pipeline run get_channel --pipeline-arg channel="C012ABCDXYZ"
pipeline "get_channel" {
  title       = "Get Channel"
  description = "Get information about a Slack channel."

  param "token" {
    type        = string
    default     = var.token
    description = local.token_param_description
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  step "http" "get_channel" {
    url    = "https://slack.com/api/conversations.info"
    method = "post"

    request_headers = {
      Content-Type  = "application/x-www-form-urlencoded"
      Authorization = "Bearer ${param.token}"
    }

    request_body = "channel=${param.channel}"
  }

  output "channel" {
    value       = step.http.get_channel.response_body.channel
    description = "Channel details."
  }
}
