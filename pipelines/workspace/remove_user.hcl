// NOTE: requires user token and supported for Enterprise plan only
pipeline "remove_user" {
  description = "Remove user to a slack workspace."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "user_id" {
    description = "The ID of the user to remove."
    type        = string
  }

  param "team_id" {
    description = "The ID (T1234) of the workspace."
    type        = string
  }

  step "http" "invite_user" {
    title  = "Remove from a workspace"
    url    = "https://slack.com/api/admin.users.remove"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      user_id = param.user_id
      team_id = param.team_id
    })
  }

}
