pipeline "archive_channel" {
  title       = "Archive Channel"
  description = "Archives a conversation."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = var.default_cred
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

    # TODO: Remove extra try() once https://github.com/turbot/flowpipe/issues/387 is resolved
    throw {
      if      = result.response_body.ok == false
      message = try(result.response_body.error, "")
    }

  }
}
