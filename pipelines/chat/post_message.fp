pipeline "post_message" {
  title       = "Post Message"
  description = "Sends a message to a channel."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = var.default_cred
  }

  param "text" {
    type        = string
    description = "The formatted text to describe the content of the message."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  param "unfurl_links" {
    type        = bool
    description = "Pass true to enable unfurling of primarily text-based content."
    optional    = true
  }

  param "unfurl_media" {
    type        = bool
    description = "Pass false to disable unfurling of media content."
    optional    = true
  }

  param "thread_ts" {
    type        = string
    description = "Provide another message's 'ts' value to make this message a reply. Avoid using a reply's 'ts' value; use its parent instead."
    optional    = true
  }

  step "http" "post_message" {
    method = "post"
    url    = "https://slack.com/api/chat.postMessage"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      for name, value in param : name => value if value != null && !contains(["cred"], name)
    })

    # TODO: Remove extra try() once https://github.com/turbot/flowpipe/issues/387 is resolved
    throw {
      if      = result.response_body.ok == false
      message = try(result.response_body.error, "")
    }
  }

  output "message" {
    description = "Message details."
    value       = step.http.post_message.response_body.message
  }
}
