pipeline "test_create_channel" {
  title       = "Test Create Channel"
  description = "Test the create_channel pipeline."

  tags = {
    type = "test"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
      channel    = param.channel_to_create
      cred       = param.cred
      is_private = param.is_private
    }
  }

  step "pipeline" "get_channel" {
    if       = !is_error(step.pipeline.create_channel)
    pipeline = pipeline.get_channel
    args = {
      channel = step.pipeline.create_channel.output.channel.id
      cred    = param.cred
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "archive_channel" {
    if = !is_error(step.pipeline.create_channel)

    pipeline = pipeline.archive_channel
    args = {
      channel = step.pipeline.create_channel.output.channel.id
      cred    = param.cred
    }
  }

  output "channel" {
    description = "Channel name used in the test."
    value       = param.channel_to_create
  }

  output "create_channel" {
    description = "Check for pipeline.create_channel."
    value       = !is_error(step.pipeline.create_channel) ? "pass" : "fail: ${step.pipeline.create_channel.errors}"
  }

  output "get_channel" {
    description = "Check for pipeline.get_channel."
    value       = !is_error(step.pipeline.get_channel) ? "pass" : "fail: ${step.pipeline.get_channel.errors}"
  }

  output "archive_channel" {
    description = "Check for pipeline.archive_channel."
    value       = !is_error(step.pipeline.archive_channel) ? "pass" : "fail: ${step.pipeline.archive_channel.errors}"
  }
}
