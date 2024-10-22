// usage: flowpipe pipeline run test_post_blocks --arg blocks="[ { \"type\" : \"section\", \"text\" : { \"type\" : \"mrkdwn\", \"text\" : \"*Hello from test_post_blocks*\"} } ]" --arg channel="random"
pipeline "test_post_blocks" {
  title       = "Test Post Message"
  description = "Test the post_message pipeline."

  param "conn" {
    type        = connection.slack
    description = local.conn_param_description
    default     = connection.slack.default
  }

  param "blocks" {
    type        = string
    default     = "Hello World from test_post_blocks pipeline."
    description = "The json of the blocks layout to be published."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send blocks to. Can be an encoded ID, or a name."
  }

  step "pipeline" "post_message" {
    pipeline = pipeline.post_message
    args = {
      conn    = param.conn
      channel = param.channel
      blocks  = param.blocks
    }
  }

  step "pipeline" "get_channel_id" {
    pipeline = pipeline.get_channel_id
    args = {
      channel_name = param.channel
    }
  }

  step "pipeline" "delete_message" {
    if       = !is_error(step.pipeline.post_message)
    pipeline = pipeline.delete_message
    args = {
      conn    = param.conn
      channel = step.pipeline.get_channel_id.output.channel_id
      ts      = step.pipeline.post_message.output.message.ts
    }
  }

  output "channel" {
    description = "Channel name used in the test."
    value       = param.channel
  }

  output "post_message" {
    description = "Check for pipeline.post_message."
    value       = !is_error(step.pipeline.post_message) ? "pass" : "fail: ${step.pipeline.post_message.errors}"
  }

  output "delete_message" {
    description = "Check for pipeline.delete_message."
    value       = !is_error(step.pipeline.delete_message) ? "pass" : "fail: ${step.pipeline.delete_message.errors}"
  }
}
