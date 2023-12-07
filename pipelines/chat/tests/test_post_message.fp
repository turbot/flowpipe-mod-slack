// usage: flowpipe pipeline run test_post_message --pipeline-arg message="Hello World"
pipeline "test_post_message" {
  title       = "Test Post Message"
  description = "Test the post_message pipeline."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "message" {
    type        = string
    default     = "Hello World from test_post_message pipeline."
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  step "pipeline" "post_message" {
    pipeline = pipeline.post_message
    args = {
      cred    = param.cred
      channel = param.channel
      message = param.message
    }
  }

  step "pipeline" "delete_message" {
    if       = !is_error(step.pipeline.post_message)
    pipeline = pipeline.delete_message
    args = {
      cred    = param.cred
      channel = param.channel
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
