pipeline "update_message" {
  title       = "Update Message"
  description = "Updates a message."

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
    description = "Channel containing the message to be updated."
  }

  param "ts" {
    type        = string
    description = "Timestamp of the message to be updated."
  }

  step "http" "update_message" {
    method = "post"
    url    = "https://slack.com/api/chat.update"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      channel = param.channel
      text    = param.text
      ts      = param.ts
    })

    # TODO: Remove extra try() once https://github.com/turbot/flowpipe/issues/387 is resolved
    throw {
      if      = result.response_body.ok == false
      message = try(result.response_body.error, "")
    }
  }

  output "message" {
    description = "Message details."
    value       = step.http.update_message.response_body.message
  }
}