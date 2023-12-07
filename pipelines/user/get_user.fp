pipeline "get_user" {
  title       = "Get User"
  description = "Retrieve a user's profile information, including their custom status."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "user" {
    type        = string
    description = "User to retrieve profile info for."
  }

  step "http" "get_user" {
    method = "post"
    url    = "https://slack.com/api/users.info"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode({
      user = param.user
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

  output "profile" {
    description = "User profile details."
    value       = step.http.get_user.response_body.profile
  }
}
