pipeline "test_invite_user" {
  title       = "Test Invite User"
  description = "Test the invite_user pipeline."

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

  param "users" {
    type        = list(string)
    default     = ["UB1BZ6QLV"]
    description = "A comma separated list of user IDs. Up to 1000 users may be listed."
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

    # Ignore errors so we can delete channel
    error {
      ignore = true
    }
  }

  step "pipeline" "invite_user" {
    if       = step.pipeline.get_channel.channel.ok == true
    pipeline = pipeline.invite_user
    args = {
      channel = step.pipeline.create_channel.channel.channel.id
      users   = param.users
    }

    # Ignore errors so we can delete channel
    error {
      ignore = true
    }
  }

  step "pipeline" "archive_channel" {
    if = step.pipeline.create_channel.channel.ok == true
    # Don't run before we've had a chance to remove users
    depends_on = [step.pipeline.invite_user]

    pipeline = pipeline.archive_channel
    args = {
      channel = step.pipeline.get_channel.channel.channel.id
    }
  }

  output "channel" {
    description = "Channel name used in the test."
    value       = param.channel_to_create
  }

  output "users" {
    description = "User IDs used in the test."
    value       = param.users
  }

  output "create_channel" {
    description = "Check for pipeline.create_channel."
    value       = step.pipeline.create_channel.channel.ok == true ? "pass" : "fail: ${step.pipeline.create_channel.channel.error}"
  }

  output "get_channel" {
    description = "Check for pipeline.get_channel."
    value       = step.pipeline.get_channel.channel.ok == true ? "pass" : "fail: ${step.pipeline.get_channel.channel.error}"
  }

  output "invite_user" {
    description = "Check for pipeline.invite_user."
    value       = step.pipeline.invite_user.invite.ok == true ? "pass" : "fail: ${step.pipeline.invite_user.invite.error}"
  }

  output "archive_channel" {
    description = "Check for pipeline.archive_channel."
    value       = step.pipeline.archive_channel.channel.ok == true ? "pass" : "fail: ${step.pipeline.archive_channel.channel.error}"
  }
}
