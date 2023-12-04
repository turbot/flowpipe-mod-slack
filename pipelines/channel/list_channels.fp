pipeline "list_channels" {
  title       = "List Channels"
  description = "Lists all channels in a Slack team."

  param "cred" {
    type        = string
    description = "Name for credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "types" {
    type        = list(string)
    default     = ["public_channel"]
    description = "Mix and match channel types by providing a comma-separated list of any combination of public_channel, private_channel, mpim, im."
  }

  param "exclude_archived" {
    type        = bool
    default     = false
    description = "Set to true to exclude archived channels from the list."
  }

  # TODO: Add pagination support
  step "http" "list_channels" {
    url    = "https://slack.com/api/conversations.list"
    method = "get"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = jsonencode(
      merge(
        { for name, value in param : name => value if value != null && !contains(["cred"], name) },
        { types = join(",", param.types) },
      )
    )

    # TODO: Remove extra try() once https://github.com/turbot/flowpipe/issues/387 is resolved
    throw {
      if      = result.response_body.ok == false
      message = try(result.response_body.error, "")
    }
  }

  output "channels" {
    description = "List of channel details."
    value       = try(step.http.list_channels.response_body.channels, [])
  }
}
