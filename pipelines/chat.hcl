pipeline "post_message" {

  param "slack_token" {
    type = string
    // default = var.slack_token // TODO: This is not implemented yet, check later!
  }

  param "message" {
    type    = string
    default = "Hello from flowpipe pipeline post_message"
  }

  param "channel" {
    type = string
    // default = "ABCD0XYZ1" // using channel ID works
    default = "random" // using channel name also works
  }

  step "http" "post_message" {
    url    = "https://slack.com/api/chat.postMessage"
    method = "post"

    request_headers = {
      Content-Type = "application/json"
      // Authorization = "Bearer ${param.slack_token}" // TODO: Use param when variables are accepted.
      Authorization = "Bearer ${var.slack_token}"
    }

    request_body = jsonencode({
      channel = "${param.channel}"
      text    = "${param.message}"
    })
  }

  output "response_body" {
    value = step.http.post_message.response_body
  }
  output "response_headers" {
    value = step.http.post_message.response_headers
  }
  output "status_code" {
    value = step.http.post_message.status_code
  }

}
