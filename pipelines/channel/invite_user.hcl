// usage: flowpipe pipeline run invite_user --pipeline-arg channel="C012ABCDXYZ" --pipeline-arg 'users=["UB1XY0ABC", "UGABCD1KL"]'
pipeline "invite_user" {
  title       = "Invite User"
  description = "Invite user(s) to a slack channel."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "channel" {
    type        = string
    default     = var.channel
    description = "The ID of the public or private channel to invite user(s) to."
  }

  param "users" {
    type        = list(string)
    description = "A comma separated list of user IDs. Up to 1000 users may be listed."
  }

  step "http" "invite_user" {
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

  output "invite" {
    value       = step.http.invite_user.response_body
    description = "Invitation details."
  }
}
