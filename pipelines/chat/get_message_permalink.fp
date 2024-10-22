pipeline "get_message_permalink" {
  title       = "Get Message Permalink"
  description = "Retrieve a permalink URL for a specific extant message."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "channel" {
    type        = string
    description = "The ID of the conversation or channel containing the message."
  }

  param "message_ts" {
    type        = string
    description = "A message's ts value, uniquely identifying it within a channel."
  }

  step "http" "get_message_permalink" {
    method = "get"
    url    = "https://slack.com/api/chat.getPermalink?channel=${param.channel}&message_ts=${param.message_ts}"

    request_headers = {
      Content-Type  = "application/x-www-form-urlencoded"
      Authorization = "Bearer ${param.conn.token}"
    }

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

  output "permalink" {
    description = "Message Permalink URL."
    value       = step.http.get_message_permalink.response_body.permalink
  }
}
