// usage: flowpipe pipeline run test_post_message --pipeline-arg message="Hello World"
pipeline "test_post_message" {
  title       = "Test Post Message"
  description = "Test the post_message pipeline."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "message" {
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
      message = param.message
    }
  }

  step "pipeline" "delete_message" {
    if = step.pipeline.post_message.message.ok == true

    pipeline = pipeline.delete_message
    args = {
      token   = param.token
      channel = param.channel
      ts      = step.pipeline.post_message.message.ts
    }
  }

  output "channel" {
    description = "Channel name used in the test."
    value       = param.channel
  }

  output "post_message" {
    description = "Check for pipeline.post_message."
    value       = step.pipeline.post_message.message.ok == true ? "succeeded" : "failed: ${step.pipeline.post_message.message.error}"
  }

  output "delete_message" {
    description = "Check for pipeline.delete_message."
    value       = step.pipeline.delete_message.message.ok == true ? "succeeded" : "failed: ${step.pipeline.delete_message.message.error}"
  }
}
