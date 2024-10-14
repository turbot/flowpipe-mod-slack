pipeline "get_channel" {
  title       = "Get Channel"
  description = "Retrieve information about a conversation."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "channel" {
    type        = string
    description = "Conversation ID to learn more about."
  }

  step "http" "get_channel" {
    method = "post"
    url    = "https://slack.com/api/conversations.info"

    request_headers = {
      Content-Type  = "application/x-www-form-urlencoded"
      Authorization = "Bearer ${param.conn.token}"
    }

    request_body = "channel=${param.channel}"

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

  output "channel" {
    description = "The conversation details."
    value       = step.http.get_channel.response_body.channel
  }
}
