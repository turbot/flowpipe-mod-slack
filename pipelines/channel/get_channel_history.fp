// usage: flowpipe pipeline run get_channel_history --pipeline-arg channel="C012ABCDXYZ"
pipeline "get_channel_history" {
  title       = "Get Channel History"
  description = "Fetches a conversation's history of messages and events."

  param "token" {
    type        = string
    default     = var.token
    description = local.token_param_description
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  param "limit" {
    type        = number
    description = "The maximum number of items to return. Fewer than the requested number of items may be returned, even if the end of the users list hasn't been reached."
    default     = 100
  }

  param "oldest" {
    type        = string
    description = "Start of time range of messages to include in results."
    default     = 0
  }

  step "http" "get_channel_history" {
    url    = "https://slack.com/api/conversations.history"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel = param.channel
      limit   = param.limit
      oldest  = param.oldest
    })
  }

  output "channel_history" {
    value       = step.http.get_channel_history.response_body.messages
    description = "Channel history details."
  }
}
