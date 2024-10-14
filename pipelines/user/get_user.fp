pipeline "get_user" {
  title       = "Get User"
  description = "Retrieve a user's profile information, including their custom status."

  tags = {
    type = "featured"
  }

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
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
      Authorization = "Bearer ${param.conn.token}"
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
