pipeline "open_conversation" {
  description = "Opens or resumes a direct message or multi-person direct message."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "users" {
    type        = list(string)
    description = "Comma separated lists of users. If only one user is included, this creates a 1:1 DM. The ordering of the users is preserved whenever a multi-person direct message is returned. Supply a channel when not supplying users."
  }

  step "http" "open_conversation" {
    title  = "Opens a direct message"
    url    = "https://slack.com/api/conversations.open"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      users = param.users
    })
  }

}
