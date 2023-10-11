// // requires user token xoxp-xxxxxxxxx-xxxx
// Get user
pipeline "get_user" {
  description = "Retrieve a user's profile information, including their custom status."
  param "token" {
    type = string
    default = var.token
  }

  param "user" {
    type = string
  }
  
  step "http" "get_user" {
      url                = "https://slack.com/api/users.profile.get"
      method             = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      user = param.user
    })
  }

  output "response_body" {
    value = step.http.get_user.response_body
  }
  output "response_headers" {
    value = step.http.get_user.response_headers
  }
  output "status_code" {
    value = step.http.get_user.status_code
  }
}
