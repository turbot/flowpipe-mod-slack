pipeline "kick_users_from_channel" {
  title       = "Remove Users from Channel"
  description = "Removes users from a Slack channel."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "channel" {
    type        = string
    description = "The ID of the public or private channel to remove user(s) from."
  }

  param "users" {
    type        = list(string)
    description = "A list of user IDs to remove from the channel."
  }

  step "http" "remove_user_from_channel" {
    for_each = param.users

    method = "post"
    url    = "https://slack.com/api/conversations.kick"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.conn.token}"
    }

    request_body = jsonencode({
      channel = param.channel
      user    = each.value
    })

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }
  }

  output "kicked_users" {
    description = "List of users successfully removed from the channel."
    value       = [for user in param.users: user if step.http.remove_user_from_channel[user].response_body.ok == true]
  }
}
