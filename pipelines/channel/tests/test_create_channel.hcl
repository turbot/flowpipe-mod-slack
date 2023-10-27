pipeline "test_create_channel" {
  title       = "Test Create Channel"
  description = "Test the create_channel pipeline."

  param "token" {
    type        = string
    default     = var.token
    description = "Authentication token bearing required scopes."
  }

  param "channel_to_create" {
    type        = string
    default     = "flowpipe-test-channel-${uuid()}"
    description = "Name of the public or private channel to create."
  }

  param "is_private" {
    type        = bool
    default     = false
    description = "Create a private channel instead of a public one"
  }

  step "pipeline" "create_channel" {
    pipeline = pipeline.create_channel
    args = {
      token      = param.token
      channel    = param.channel_to_create
      is_private = param.is_private
    }
  }

  step "pipeline" "get_channel" {
    if       = step.pipeline.create_channel.channel.ok == true
    pipeline = pipeline.get_channel
    args = {
      channel = step.pipeline.create_channel.channel.channel.id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "archive_channel" {
    if = step.pipeline.create_channel.channel.ok == true

    pipeline = pipeline.archive_channel
    args = {
      channel = step.pipeline.get_channel.channel.channel.id
    }
  }

  output "channel" {
    description = "Channel name used in the test."
    value       = param.channel_to_create
  }

  output "create_channel" {
    description = "Check for pipeline.create_channel."
    value       = step.pipeline.create_channel.channel.ok == true ? "succeeded" : "failed: ${step.pipeline.create_channel.channel.error}"
  }

  output "get_channel" {
    description = "Check for pipeline.get_channel."
    value       = step.pipeline.get_channel.channel.ok == true ? "succeeded" : "failed: ${step.pipeline.get_channel.channel.error}"
  }

  output "archive_channel" {
    description = "Check for pipeline.archive_channel."
    value       = step.pipeline.archive_channel.channel.ok == true ? "succeeded" : "failed: ${step.pipeline.archive_channel.channel.error}"
  }
}
