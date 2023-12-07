pipeline "create_channel" {
  title       = "Create Channel"
  description = "Initiates a public or private channel-based conversation."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "channel_name" {
    type        = string
    description = "Name of the public or private channel to create."
  }

  param "is_private" {
    type        = bool
    description = "Create a private channel instead of a public one"
    default     = true
  }

  param "team_id" {
    type        = string
    description = "Encoded team id to create the channel in, required if org token is used."
    optional    = true
  }

  step "http" "create_channel" {
    method = "post"
    url    = "https://slack.com/api/conversations.create"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      name       = param.channel
      is_private = param.is_private
    })

    # TODO: Remove extra try() once https://github.com/turbot/flowpipe/issues/387 is resolved
    throw {
      if      = result.response_body.ok == false
      message = try(result.response_body.error, "")
    }
  }

  output "channel" {
    description = "Conversation object."
    value       = step.http.create_channel.response_body.channel
  }
}
