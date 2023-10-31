// usage: flowpipe pipeline run test_update_message --pipeline-arg initial_message="Hello World" --pipeline-arg updated_message="Hello New World"
pipeline "test_update_message" {
  title       = "Test Update Message"
  description = "Test the update_message pipeline."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "initial_message" {
    type        = string
    description = "The formatted text of the message to be published."
  }

  param "updated_message" {
    type        = string
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    default     = var.channel
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  step "pipeline" "post_message" {
    pipeline = pipeline.post_message
    args = {
      token   = param.token
      channel = param.channel
      message = param.initial_message
    }
  }

  step "pipeline" "update_message" {
    if       = step.pipeline.post_message.message.ok == true
    pipeline = pipeline.update_message
    args = {
      token   = param.token
      channel = param.channel
      message = param.updated_message
      ts      = step.pipeline.post_message.message.ts
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_message" {
    if = step.pipeline.update_message.message.ok == true

    pipeline = pipeline.delete_message
    args = {
      token   = param.token
      channel = param.channel
      ts      = step.pipeline.update_message.message.ts
    }
  }

  output "channel" {
    description = "Channel name used in the test."
    value       = param.channel
  }

  output "post_message" {
    description = "Check for pipeline.post_message."
    value       = step.pipeline.post_message.message.ok == true ? "pass" : "fail: ${step.pipeline.post_message.message.error}"
  }

  output "update_message" {
    description = "Check for pipeline.update_message."
    value       = step.pipeline.update_message.message.ok == true ? "pass" : "fail: ${step.pipeline.update_message.message.error}"
  }

  output "delete_message" {
    description = "Check for pipeline.delete_message."
    value       = step.pipeline.delete_message.message.ok == true ? "pass" : "fail: ${step.pipeline.delete_message.message.error}"
  }
}
