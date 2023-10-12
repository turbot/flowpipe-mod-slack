pipeline "create_channel" {
  description = "Create a slack channel."

  param "token" {
    type    = string
    default = var.token
  }

  param "channel" {
    type = string
  }

  param "is_private" {
    type    = boolean
    default = true
  }

  step "http" "create_channel" {
    title  = "Create channel"
    url    = "https://slack.com/api/conversations.create"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      name       = param.channel
      is_private = param.is_private

    })
  }

  output "response_body" {
    value = step.http.create_channel.response_body
  }
  output "response_headers" {
    value = step.http.create_channel.response_headers
  }
  output "status_code" {
    value = step.http.create_channel.status_code
  }

}
