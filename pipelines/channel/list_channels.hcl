pipeline "list_channels" {
  description = "List slack channels channel."

  param "token" {
    type    = string
    default = var.token
  }

  step "http" "list_channels" {
    title  = "List channels"
    url    = "https://slack.com/api/conversations.list"
    method = "post"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }
  }

  output "channels" {
    description = "List of channels"
    value       = jsondecode(step.http.list_channels.response_body).channels
  }
  output "response_body" {
    value = step.http.list_channels.response_body
  }
  output "response_headers" {
    value = step.http.list_channels.response_headers
  }
  output "status_code" {
    value = step.http.list_channels.status_code
  }

}
