pipeline "open_message" {
  title       = "Open Message"
  description = "Open or resume a direct message or multi-person direct message."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "users" {
    type        = list(string)
    description = "Comma separated lists of users. If only one user is included, this creates a 1:1 DM. The ordering of the users is preserved whenever a multi-person direct message is returned."
  }

  step "http" "open_message" {
    method = "post"
    url    = "https://slack.com/api/conversations.open"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.conn.token}"
    }

    request_body = jsonencode({
      users = join(",", param.users)
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

  output "channel" {
    description = "Conversation details."
    value       = step.http.open_message.response_body.channel
  }
}
