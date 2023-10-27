// usage: flowpipe pipeline run test_schedule_message  --pipeline-arg message="Hello World from terminal, this runs after 30 seconds" --pipeline-arg "post_at=$(( $(date +%s) + 30 ))"
pipeline "test_schedule_message" {
  title       = "Test Post Message"
  description = "Test the schedule_message pipeline."

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
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  param "post_at" {
    type        = number // Unix EPOCH timestamp of time in future to send the message. Help: https://www.epochconverter.com/
    description = "Unix EPOCH timestamp of time in future to send the message."
  }

  step "pipeline" "schedule_message" {
    pipeline = pipeline.schedule_message
    args = {
      token   = param.token
      channel = param.channel
      message = param.message
      post_at = param.post_at
    }
  }

  step "pipeline" "list_scheduled_messages" {
    if = step.pipeline.schedule_message.scheduled_message.ok == true

    pipeline = pipeline.list_scheduled_messages
    args = {
      token = param.token
    }
  }

  output "channel" {
    description = "Channel name used in the test."
    value       = param.channel
  }

  output "schedule_message" {
    description = "Check for pipeline.schedule_message."
    value       = step.pipeline.schedule_message.scheduled_message.ok == true ? "succeeded" : "failed: ${step.pipeline.schedule_message.scheduled_message.error}"
  }

  output "list_scheduled_messages" {
    description = "Check for pipeline.list_scheduled_messages."
    value       = step.pipeline.list_scheduled_messages.scheduled_messages.ok == true && length([for schedule in step.pipeline.list_scheduled_messages.scheduled_messages.scheduled_messages : schedule.id if schedule.id == step.pipeline.schedule_message.scheduled_message.scheduled_message_id]) > 0 ? "succeeded" : "failed: ${step.pipeline.list_scheduled_messages.scheduled_messages.error}"
  }
}
