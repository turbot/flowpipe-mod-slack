pipeline "post_message" {
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

  param "unfurl_links" {
    type = boolean
    default = false
  }

  param "unfurl_media" {
    type = boolean
    default = false
  }

  param "thread_ts" {
    type = string
    default = ""
  }

  step "http" "post_message" {
    title = "Post message"
    url    = "https://slack.com/api/chat.postMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel      = param.channel
      text         = param.message
      unfurl_links = param.unfurl_links
      unfurl_media = param.unfurl_media
      thread_ts    = param.thread_ts
    })
  }

  output "ts" {
    value = jsondecode(step.http.post_message.response_body).ts
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
