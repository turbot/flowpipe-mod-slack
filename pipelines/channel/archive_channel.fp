pipeline "archive_channel" {
  title       = "Archive Channel"
  description = "Archives a conversation."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
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
      Authorization = "Bearer ${param.conn.token}"
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
