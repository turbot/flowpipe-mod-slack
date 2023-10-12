pipeline "list_channels" {
  description = "List slack channels channel."

  param "token" {
    type    = string
    default = var.token
  }

  param "filter_channel_by_name" {
    type    = string
    default = "random"
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
  // output "channels" {
  //   description = "List of channels"
  //   value       = jsondecode(step.http.list_channels.response_body).channels
  // }
  // output "response_body" {
  //   value = step.http.list_channels.response_body
  // }
  // output "response_headers" {
  //   value = step.http.list_channels.response_headers
  // }
  output "status_code" {
    value = step.http.list_channels.status_code
  }

}
