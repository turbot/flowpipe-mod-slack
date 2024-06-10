// usage: flowpipe pipeline run test_update_message --pipeline-arg initial_message="Hello World" --pipeline-arg updated_message="Hello New World"
pipeline "test_update_message" {
  title       = "Test Update Message"
  description = "Test the update_message pipeline."

  tags = {
    type = "test"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "initial_message" {
    type        = string
    default     = "Hello World from test_update_message pipeline."
    description = "The formatted text of the message to be published."
  }

  param "updated_message" {
    type        = string
    default     = "Hello World from test_update_message pipeline - Updated."
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  step "pipeline" "post_message" {
    pipeline = pipeline.post_message
    args = {
      channel = param.channel
      cred    = param.cred
      message = param.initial_message
    }
  }

  step "pipeline" "update_message" {
    if       = !is_error(step.pipeline.post_message)
    pipeline = pipeline.update_message
    args = {
      channel = param.channel
      cred    = param.cred
      message = param.updated_message
      ts      = step.pipeline.post_message.output.message.ts
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_message" {
    if         = !is_error(step.pipeline.post_message)
    depends_on = [step.pipeline.update_message]

    pipeline = pipeline.delete_message
    args = {
      channel = param.channel
      cred    = param.cred
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

  output "update_message" {
    description = "Check for pipeline.update_message."
    value       = !is_error(step.pipeline.update_message) ? "pass" : "fail: ${step.pipeline.update_message.errors}"
  }

  output "delete_message" {
    description = "Check for pipeline.delete_message."
    value       = !is_error(step.pipeline.delete_message) ? "pass" : "fail: ${step.pipeline.delete_message.errors}"
  }
}
