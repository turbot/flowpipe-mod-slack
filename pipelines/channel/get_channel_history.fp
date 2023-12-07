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

  # TODO: Add pagination support once https://github.com/turbot/flowpipe/issues/339 is resolved
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
      limit   = 1000
    })

    # TODO: Remove extra try() once https://github.com/turbot/flowpipe/issues/387 is resolved
    throw {
      if      = result.response_body.ok == false
      message = try(result.response_body.error, "")
    }
  }

  output "messages" {
    description = "Channel history."
    value       = step.http.get_channel_history.messages
  }
}
