pipeline "delete_scheduled_message" {
  title       = "Delete Scheduled Message"
  description = "Delete a pending scheduled message from the queue."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "channel" {
    type        = string
    description = "The channel the scheduled_message is posting to."
  }

  param "scheduled_message_id" {
    type        = string
    description = "scheduled_message_id returned from call to pipeline.schedule_message."
  }

  step "http" "delete_scheduled_message" {
    method = "post"
    url    = "https://slack.com/api/chat.deleteScheduledMessage"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.conn.token}"
    }

    request_body = jsonencode({
      channel              = param.channel
      scheduled_message_id = param.scheduled_message_id
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }
}
