pipeline "post_message" {

  param "slack_token" {
    type    = string
    default = var.slack_token
  }

  param "slack_message" {
    type    = string
    default = var.slack_message
  }

  param "slack_channel_name" {
    type    = string
    default = var.slack_channel_name
  }

  step "http" "post_message" {
    url    = "https://slack.com/api/chat.postMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.slack_token}"
    }

    request_body = jsonencode({
      channel      = "${param.slack_channel_name}"
      text         = "${param.slack_message}"
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
