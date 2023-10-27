// usage: flowpipe pipeline run remove_user --pipeline-arg channel="C012ABCDXYZ" --pipeline-arg user="UGABCD1KL"
pipeline "remove_user" {
  title       = "Remove User"
  description = "Remove user(s) from a slack channel."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "channel" {
    type        = string
    default     = var.channel
    description = "ID of channel to remove user from."
  }

  param "user" {
    type        = string
    description = "User ID to be removed."
  }

  step "http" "remove_user" {
    url    = "https://slack.com/api/conversations.kick"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel = param.channel
      user    = param.user
    })
  }
}
