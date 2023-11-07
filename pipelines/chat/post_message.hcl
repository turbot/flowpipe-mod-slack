// usage: flowpipe pipeline run post_message --pipeline-arg message="hello world"
pipeline "post_message" {
  title       = "Post Message"
  description = "Post a message to a channel."

  param "token" {
    type        = string
    default     = var.token
    description = local.token_param_description
  }

  param "message" {
    type        = string
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    default     = var.channel
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  param "unfurl_links" {
    type        = bool
    default     = true
    description = "Pass true to enable unfurling of primarily text-based content."
  }

  param "unfurl_media" {
    type        = bool
    default     = true
    description = "Pass false to disable unfurling of media content."
  }

  param "thread_ts" {
    type        = string
    optional    = true
    description = "Provide another message's ts value to make this message a reply. Avoid using a reply's ts value; use its parent instead."
  }

  step "http" "post_message" {
    url    = "https://slack.com/api/chat.postMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel      = param.channel
      text         = param.message
      thread_ts    = param.thread_ts
      unfurl_links = param.unfurl_links
      unfurl_media = param.unfurl_media
    })
  }

  output "message" {
    value       = step.http.post_message.response_body.message
    description = "Message details."
  }
}
