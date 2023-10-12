pipeline "create_channel" {
  description = "Create a slack channel."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "channel" {
    description = "Name of the public or private channel to create."
    type        = string
  }

  param "is_private" {
    type        = boolean
    description = "Create a private channel instead of a public one"
    default     = true
  }

  step "http" "create_channel" {
    title  = "Create channel"
    url    = "https://slack.com/api/conversations.create"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      name       = param.channel
      is_private = param.is_private

    })
  }

}
