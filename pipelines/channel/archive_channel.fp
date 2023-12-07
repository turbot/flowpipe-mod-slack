pipeline "archive_channel" {
  title       = "Archive Channel"
  description = "Archives a conversation."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "channel" {
    type        = string
    description = "ID of conversation to archive."
  }

  step "http" "archive_channel" {
    method = "post"
    url    = "https://slack.com/api/conversations.archive"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      channel = param.channel
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }

  }
}
