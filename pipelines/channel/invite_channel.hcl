pipeline "invite_channel" {
  description = "Invite user(s) to a slack channel."

  param "token" {
    type    = string
    default = var.token
  }

  param "channel" {
    type = string
  }

  param "users" {
    type    = list(string)
  }

  step "http" "invite_channel" {
    title = "Invite to a channel"
    url    = "https://slack.com/api/conversations.invite"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel       = param.channel
      users = param.users

    })
  }

  output "response_body" {
    value = step.http.invite_channel.response_body
  }
  output "response_headers" {
    value = step.http.invite_channel.response_headers
  }
  output "status_code" {
    value = step.http.invite_channel.status_code
  }

}
