pipeline "post_message" {
  description = "Send a message to a channel."

  param "token" {
    type    = string
    description = "Slack app token used to connect to the API."
    default = var.token
  }

  param "message" {
    type        = string
    description = "The formatted text of the message to be published."
    default     = "Test message from Flowpipe"
  }

  param "channel" {
    type        = string
    description = "Channel containing the message to be updated."
    default     = var.channel
  }

  param "unfurl_links" {
    type        = boolean
    description = "Pass true to enable unfurling of primarily text-based content."
    default     = true
  }

  param "unfurl_media" {
    type        = boolean
    description = "Pass false to disable unfurling of media content."
    default     = true
  }

  param "thread_ts" {
    type        = string
    description = "Provide another message's ts value to make this message a reply. Avoid using a reply's ts value; use its parent instead."
    optional    = true
  }

  step "http" "post_message" {
    title  = "Post message"
    url    = "https://slack.com/api/chat.postMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel      = param.channel
      text         = param.message
      unfurl_links = param.unfurl_links
      unfurl_media = param.unfurl_media
      thread_ts    = param.thread_ts
    })
  }

  output "ts" {
    value = jsondecode(step.http.post_message.response_body).ts
  }

}
