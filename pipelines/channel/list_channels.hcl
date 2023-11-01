// usage: flowpipe pipeline run list_channels --pipeline-arg filter_channel_by_name="random"
pipeline "list_channels" {
  title       = "List Channels"
  description = "Lists all channels in a Slack team."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "filter_channel_by_name" {
    type        = string
    optional    = true
    description = "Filter the channel by name to get the channel ID."
  }

  param "types" {
    type        = string
    default     = "public_channel"
    description = "Mix and match channel types by providing a comma-separated list of any combination of public_channel, private_channel, mpim, im"
  }

  param "exclude_archived" {
    type        = bool
    default     = false
    description = "Set to true to exclude archived channels from the list."
  }

  step "http" "list_channels" {
    url    = "https://slack.com/api/conversations.list"
    method = "get"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      exclude_archived = param.exclude_archived
      types            = param.types
    })
  }

  output "channels" {
    description = "List of all channels."
    value       = step.http.list_channels.response_body
  }

  output "channel_id" {
    description = "Get the Channel ID by name."
    value       = join("", [for channel in step.http.list_channels.response_body.channels : channel.id if channel.name == param.filter_channel_by_name])
  }
}
