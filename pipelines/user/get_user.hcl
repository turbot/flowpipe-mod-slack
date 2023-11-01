pipeline "get_user" {
  title       = "Get User"
  description = "Retrieve the current user's or bot's profile information, including their custom status."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "user" {
    type        = string
    description = "User to get information on."
  }

  step "http" "get_user" {
    url    = "https://slack.com/api/users.info"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      user = param.user
    })
  }

  output "user" {
    value       = step.http.get_user.response_body
    description = "User details."
  }
}
