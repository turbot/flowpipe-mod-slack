pipeline "schedule_message" {
  description = "Send a message to a channel."

  param "token" {
    type    = string
    default = var.token
  }

  param "message" {
    type    = string
    default = "Test message from Flowpipe via schedule message"
  }

  param "channel" {
    type    = string
    default = var.channel
  }

  param "post_at" {
    type = number // Unix EPOCH timestamp of time in future to send the message. Help: https://www.epochconverter.com/
  }

  param "unfurl_links" {
    type = boolean
    default = false
  }

  param "unfurl_media" {
    type = boolean
    default = false
  }

  step "http" "schedule_message" {
    title = "Scheduled a message"
    url    = "https://slack.com/api/chat.scheduleMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel      = "${param.channel}"
      text         = "${param.message}"
      post_at      = "${param.post_at}"
      unfurl_links = "${param.unfurl_links}"
      unfurl_media = "${param.unfurl_media}"
    })
  }

  output "response_body" {
    value = step.http.schedule_message.response_body
  }
  output "response_headers" {
    value = step.http.schedule_message.response_headers
  }
  output "status_code" {
    value = step.http.schedule_message.status_code
  }

}
