pipeline "chat_post_message" {
  description = "Send a message to a channel."

  param "token" {
    type    = string
    default = var.token
  }

  param "message" {
    type    = string
    default = "Test message from Flowpipe"
  }

  param "channel" {
    type    = string
    default = var.channel
  }

  step "http" "chat_post_message" {
    url    = "https://slack.com/api/chat.postMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel      = "${param.channel}"
      text         = "${param.message}"
      unfurl_links = false
      unfurl_media = false
    })
  }

  output "response_body" {
    value = step.http.chat_post_message.response_body
  }
  output "response_headers" {
    value = step.http.chat_post_message.response_headers
  }
  output "status_code" {
    value = step.http.chat_post_message.status_code
  }

}
