pipeline "get_channel_history" {
  title       = "Get Channel History"
  description = "Fetches a conversation's history of messages and events."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "channel" {
    type        = string
    description = "Conversation ID to fetch history for."
  }

  param "oldest" {
    type        = string
    description = "Only messages after this Unix timestamp will be included in results."
    default     = 0
  }

  step "http" "get_channel_history" {
    method = "post"
    url    = "https://slack.com/api/conversations.history"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      channel = param.channel
      oldest  = param.oldest
      limit   = 200
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }

    loop {
      until = result.response_body.has_more == false

      request_body = jsonencode({
        channel = param.channel
        oldest  = param.oldest
        limit   = 200
        cursor  = result.response_body.response_metadata.next_cursor
      })
    }
  }

  output "messages" {
    description = "Channel history."
    value       = flatten([for entry in step.http.get_channel_history : entry.response_body.messages])
  }
}
