pipeline "get_current_user" {
  title       = "Get Current User Profile"
  description = "Retrieve the current user's or bot's profile information, including their custom status."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  step "http" "get_current_user" {
    url    = "https://slack.com/api/users.profile.get"
    method = "get"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }
  }

  output "user" {
    value       = step.http.get_current_user.response_body
    description = "User profile details."
  }
}
