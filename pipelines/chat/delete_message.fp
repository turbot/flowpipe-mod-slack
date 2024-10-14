pipeline "delete_message" {
  title       = "Delete Message"
  description = "Deletes a message."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "channel" {
    type        = string
    description = "Channel containing the message to be deleted."
  }

  param "ts" {
    type        = string
    description = "Timestamp of the message to be deleted."
  }

  step "http" "delete_message" {
    method = "post"
    url    = "https://slack.com/api/chat.delete"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.conn.token}"
    }

    request_body = jsonencode({
      channel = param.channel
      ts      = param.ts
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }
}
