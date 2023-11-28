// usage: flowpipe pipeline run get_message_permalink --arg message_ts="1698385111.481129" --arg channel=CEFG8LMN9
pipeline "get_message_permalink" {
  title       = "Get Message Permalink"
  description = "Retrieve a permalink URL for a specific extant message."

  param "token" {
    type        = string
    default     = var.token
    description = local.token_param_description
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  param "message_ts" {
    type        = string
    description = "A message's ts value, uniquely identifying it within a channel."
  }

  step "http" "get_message_permalink" {
    url    = "https://slack.com/api/chat.getPermalink?channel=${param.channel}&message_ts=${param.message_ts}"
    method = "get"

    request_headers = {
      Content-Type  = "application/x-www-form-urlencoded"
      Authorization = "Bearer ${param.token}"
    }
  }

  output "permalink" {
    value       = step.http.get_message_permalink.response_body.permalink
    description = "Message Permalink URL."
  }
}
