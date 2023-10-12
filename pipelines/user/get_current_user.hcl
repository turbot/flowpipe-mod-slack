// Get current user
// usage: flowpipe pipeline run get_current_user
pipeline "get_current_user" {
  description = "Retrieve the current user's or bot's profile information, including their custom status."
  param "token" {
    type    = string
    default = var.token
  }

  step "http" "get_current_user" {
    url    = "https://slack.com/api/users.profile.get"
    method = "get"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

  }

  output "response_body" {
    value = step.http.get_current_user.response_body
  }
  output "response_headers" {
    value = step.http.get_current_user.response_headers
  }
  output "status_code" {
    value = step.http.get_current_user.status_code
  }
}
