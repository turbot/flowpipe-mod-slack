pipeline "invite_users_to_channel" {
  title       = "Invite Users to Channel"
  description = "Invites users to a channel."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "channel" {
    type        = string
    description = "The ID of the public or private channel to invite user(s) to."
  }

  param "users" {
    type        = list(string)
    description = "A list of user IDs. Up to 1000 users may be listed."
  }

  step "http" "invite_users_to_channel" {
    method = "post"
    url    = "https://slack.com/api/conversations.invite"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      channel = param.channel
      users   = join(",", param.users)
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }

  }

  output "channel" {
    description = "Channel details."
    value       = step.http.invite_users_to_channel.response_body.channel
  }
}
