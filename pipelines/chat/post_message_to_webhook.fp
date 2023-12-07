pipeline "post_message_to_webhook" {
  title       = "Post Message"
  description = "Sends a message to a channel."

  tags = {
    type = "featured"
  }

  param "text" {
    type        = string
    description = "The formatted text to describe the content of the message."
  }

  param "webhook_url" {
    type        = string
    description = "The webhook URL for your workspace."
  }

  step "http" "post_message_to_webhook" {
    method = "post"
    url    = param.webhook_url

    request_headers = {
      Content-Type = "application/json"
    }

    request_body = jsonencode({
      text = param.text
    })

    throw {
      if      = result.status_code == 200 && result.response_body != "ok"
      message = "Invalid Webhook URL."
    }
  }
}
