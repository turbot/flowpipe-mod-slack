pipeline "get_channel_id" {
  title       = "Get Channel ID"
  description = "Get the ID from the channel name."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "channel_name" {
    type        = string
    description = "Name of the channel."
  }

  param "channel_types" {
    type        = list(string)
    description = "Mix and match channel types by providing a list of any combination of public_channel, private_channel, mpim, im."
    optional    = true
  }

  step "pipeline" "list_channels" {
    pipeline = pipeline.list_channels
    args = {
      conn = param.conn
      types = param.channel_types == null ? [""] : param.channel_types
    }
  }

  output "channel_id" {
    value = (
    length([for channel in step.pipeline.list_channels.output.channels : channel.id if channel.name == param.channel_name]) > 0 ?
    [for channel in step.pipeline.list_channels.output.channels : channel.id if channel.name == param.channel_name][0] :
    ""
  )
  }
}
