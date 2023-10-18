pipeline "get_user" {
  description = "Retrieve the current user's or bot's profile information, including their custom status."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  param "user" {
    type        = string
    description = "User to get info on"
  }

  step "http" "get_user" {
    url    = "https://slack.com/api/users.info"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      user = param.user
    })

  }

}
