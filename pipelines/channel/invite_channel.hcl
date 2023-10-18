pipeline "invite_channel" {
  description = "Invite user(s) to a slack channel."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "channel" {
    description = "The ID of the public or private channel to invite user(s) to."
    type        = string
  }

  param "users" {
    type        = list(string)
    description = "A comma separated list of user IDs. Up to 1000 users may be listed."
  }

  step "http" "invite_channel" {
    title  = "Invite to a channel"
    url    = "https://slack.com/api/conversations.invite"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel = param.channel
      users   = param.users
    })
  }

}
