pipeline "post_message" {

  param "slack_token" {
    type    = string
    default = var.slack_token
  }

  param "message" {
    type    = string
    default = var.message
  }

  param "channel" {
    type    = string
    default = var.channel
  }

  step "http" "post_message" {
    url    = "https://slack.com/api/chat.postMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.slack_token}"
    }

    request_body = jsonencode({
      channel      = "${param.channel}"
      text         = "${param.message}"
      unfurl_links = false
      unfurl_media = false
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
