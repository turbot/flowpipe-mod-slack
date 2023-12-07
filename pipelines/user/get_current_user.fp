pipeline "get_current_user" {
  title       = "Get Current User Profile"
  description = "Retrieve the current user's or bot's profile information, including their custom status."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  step "http" "get_current_user" {
    method = "get"
    url    = "https://slack.com/api/users.profile.get"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

  output "profile" {
    description = "User profile details."
    value       = step.http.get_current_user.response_body.profile
  }
}
