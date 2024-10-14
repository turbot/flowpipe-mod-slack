pipeline "list_scheduled_messages" {
  title       = "List Scheduled Messages"
  description = "List of scheduled messages."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  step "http" "list_scheduled_messages" {
    method = "post"
    url    = "https://slack.com/api/chat.scheduledMessages.list"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.conn.token}"
    }

    request_body = jsonencode({
      limit = 200
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }

    loop {
      until = result.response_body.response_metadata.next_cursor == ""

      request_body = jsonencode({
        channel = param.channel
        oldest  = param.oldest
        limit   = 200
        cursor  = result.response_body.response_metadata.next_cursor
      })
    }
  }

  output "scheduled_messages" {
    description = "List of pending scheduled messages."
    value       = flatten([for entry in step.http.list_scheduled_messages : entry.response_body.scheduled_messages])
  }
}
