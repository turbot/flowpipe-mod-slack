pipeline "delete_message" {
  title       = "Delete Message"
  description = "Deletes a message."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "channel" {
    type        = string
    description = "Channel containing the message to be deleted."
  }

  param "ts" {
    type        = string
    description = "Timestamp of the message to be deleted."
  }

  step "pipeline" "get_channel_id" {
    pipeline = pipeline.get_channel_id
    args = {
      channel_name = param.channel
    }
  }

  step "http" "delete_message" {
    method = "post"
    url    = "https://slack.com/api/chat.delete"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      channel = step.pipeline.get_channel_id.output.channel_id
      ts      = param.ts
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

}
