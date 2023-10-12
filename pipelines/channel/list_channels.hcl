pipeline "list_channels" {
  description = "List slack channels channel."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "filter_channel_by_name" {
    type        = string
    description = "Filter the channel by name to get the channel ID."
    optional    = true
  }

  step "http" "list_channels" {
    title  = "List channels"
    url    = "https://slack.com/api/conversations.list"
    method = "get"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      exclude_archived = true
      types            = "public_channel"
    })

  }

  output "channel_id" {
    description = "Filter a channel using the channel name."
    value       = join("", [for channel in jsondecode(step.http.list_channels.response_body).channels : channel.id if channel.name == "${param.filter_channel_by_name}"])
  }

}
