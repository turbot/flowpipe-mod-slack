pipeline "get_current_user" {
  title       = "Get Current User"
  description = "Retrieve the current user's or bot's profile information, including their custom status."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  step "http" "get_current_user" {
    method = "get"
    url    = "https://slack.com/api/users.profile.get"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.conn.token}"
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
