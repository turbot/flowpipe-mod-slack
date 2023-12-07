pipeline "list_scheduled_messages" {
  title       = "List Scheduled Messages"
  description = "List of scheduled messages."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  # TODO: Add pagination support once https://github.com/turbot/flowpipe/issues/339 is resolved
  step "http" "list_scheduled_messages" {
    method = "post"
    url    = "https://slack.com/api/chat.scheduledMessages.list"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      limit = 1000
    })

    # TODO: Remove extra try() once https://github.com/turbot/flowpipe/issues/387 is resolved
    throw {
      if      = result.response_body.ok == false
      message = try(result.response_body.error, "")
    }
  }

  output "scheduled_messages" {
    description = "List of pending scheduled messages."
    value       = step.http.list_scheduled_messages.response_body.scheduled_messages
  }
}
