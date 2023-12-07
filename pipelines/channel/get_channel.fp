pipeline "get_channel" {
  title       = "Get Channel"
  description = "Retrieve information about a conversation."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "channel" {
    type        = string
    description = "Conversation ID to learn more about."
  }

  step "http" "get_channel" {
    method = "post"
    url    = "https://slack.com/api/conversations.info"

    request_headers = {
      Content-Type  = "application/x-www-form-urlencoded"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = "channel=${param.channel}"

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

  output "channel" {
    description = "The conversation details."
    value       = step.http.get_channel.response_body.channel
  }
}
