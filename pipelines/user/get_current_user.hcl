// Get current user
// usage: flowpipe pipeline run get_current_user
pipeline "get_current_user" {
  description = "Retrieve the current user's or bot's profile information, including their custom status."

  param "token" {
    type        = string
    description = "Slack app token used to connect to the API."
    default     = var.token
  }

  step "http" "get_current_user" {
    url    = "https://slack.com/api/users.profile.get"
    method = "get"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

  }

}
