pipeline "post_message" {
  title       = "Post Message"
  description = "Sends a message to a channel."

  param "cred" {
    type        = string
    description = "Name for credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  # TODO: Update description to match API docs.
  param "text" {
    type        = string
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  # TODO: Check if these defaults match Slack's API behavior.
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
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      channel      = param.channel
      text         = param.text
      thread_ts    = param.thread_ts
      unfurl_links = param.unfurl_links
      unfurl_media = param.unfurl_media
    })

    # TODO: Remove extra try() once https://github.com/turbot/flowpipe/issues/387 is resolved
    throw {
      if      = result.response_body.ok == false
      message = try(result.response_body.error, "")
    }
  }

  output "message" {
    description = "Message details."
    value       = try(step.http.post_message.response_body.message, null)
  }
}
