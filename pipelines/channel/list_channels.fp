pipeline "list_channels" {
  title       = "List Channels"
  description = "Lists all channels in a Slack team."

  tags = {
    recommended = "true"
  }

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "types" {
    type        = list(string)
    description = "Mix and match channel types by providing a list of any combination of public_channel, private_channel, mpim, im."
    optional    = true
  }

  param "exclude_archived" {
    type        = bool
    description = "Set to true to exclude archived channels from the list."
    optional    = true
  }

  step "http" "list_channels" {
    method = "get"

    url = join("&", concat(
      ["https://slack.com/api/conversations.list?limit=200"],
      [param.types == null ? "" : "types=${join(",", param.types)}"],
      [for name, value in param : "${name}=${urlencode(value)}" if value != null && !contains(["conn", "types"], name)],
    ))

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.conn.token}"
    }

    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error
    }

    loop {
      until = result.response_body.response_metadata.next_cursor == null || result.response_body.response_metadata.next_cursor == ""

      url = join("&", concat(
        ["https://slack.com/api/conversations.list?limit=200"],
        [param.types == null ? "" : "types=${join(",", param.types)}"],
        [for name, value in param : "${name}=${urlencode(value)}" if value != null && !contains(["conn", "types"], name)],
        ["cursor=${result.response_body.response_metadata.next_cursor}"]
      ))
    }

  }

  output "channels" {
    description = "List of channel details."
    value       = flatten([for entry in step.http.list_channels : entry.response_body.channels])
  }
}
