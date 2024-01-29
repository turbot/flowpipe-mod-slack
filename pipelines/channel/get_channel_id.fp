pipeline "get_channel_id" {
  title       = "Get Channel ID"
  description = "Get the ID from the channel name."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "channel_name" {
    type        = string
    description = "Name of the channel."
  }

  step "pipeline" "list_channels" {
    pipeline = pipeline.list_channels
  }

  output "channel_id" {
    value = [for channel in step.pipeline.list_channels.output.channels : channel.id if channel.name == param.channel_name][0]
  }


}
