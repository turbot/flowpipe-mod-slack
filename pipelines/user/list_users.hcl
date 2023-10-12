pipeline "list_users" {
  description = "List users in a Slack workspace."

  param "token" {
    type    = string
    default = var.token
  }

  step "http" "list_users" {
    title  = "List users"
    url    = "https://slack.com/api/users.list"
    method = "get"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }
  }

  output "user_id" {
    description = "Filter a user using the user's email."
    value       = join("", [for user in jsondecode(step.http.list_users.response_body).members : user.id if uesr.email == "venu@turbot.com"])
  }

  output "response_body" {
    value = step.http.list_users.response_body
  }
  output "response_headers" {
    value = step.http.list_users.response_headers
  }
  output "status_code" {
    value = step.http.list_users.status_code
  }

}
