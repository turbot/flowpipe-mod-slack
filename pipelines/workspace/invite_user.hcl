// NOTE: requires user token and supported for Enterprise plan only
pipeline "invite_user" {
  description = "Invite user(s) to a slack workspace."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "channel_ids" {
    description = "A comma-separated list of channel_ids for this user to join. At least one channel is required."
    type        = string
  }

  param "email" {
    description = "The email address of the person to invite.."
    type        = string
  }

  param "team_id" {
    description = "The ID (T1234) of the workspace."
    type        = string
  }

  step "http" "invite_user" {
    title  = "Invite to a workspace"
    url    = "https://slack.com/api/admin.users.invite"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel = param.channel_ids
      email   = param.email
      team_id = param.team_id
    })
  }

}
