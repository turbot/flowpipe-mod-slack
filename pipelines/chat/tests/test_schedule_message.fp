// usage: flowpipe pipeline run test_schedule_message  --pipeline-arg "post_at=$(( $(date +%s) + 120 ))"
pipeline "test_schedule_message" {
  title       = "Test Schedule Message"
  description = "Test the schedule_message pipeline."

  tags = {
    type = "test"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "message" {
    type        = string
    default     = "Hello World from test_schedule_message pipeline."
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  // Note: You will only be able to schedule a message up to 120 days into the future.
  param "post_at" {
    type        = number // Unix EPOCH timestamp of time in future to send the message. Help: https://www.epochconverter.com/
    description = "Unix EPOCH timestamp of time in future to send the message."
  }

  step "pipeline" "schedule_message" {
    pipeline = pipeline.schedule_message
    args = {
      channel = param.channel
      cred    = param.cred
      message = param.message
      post_at = param.post_at
    }
  }

  step "pipeline" "list_scheduled_messages" {
    if = !is_error(step.pipeline.schedule_message)

    pipeline = pipeline.list_scheduled_messages
    args = {
      cred = param.cred
    }
  }

  // Note: You cannot delete scheduled messages that have already been posted to Slack or that will be posted to Slack within 60 seconds of the delete request. 
  // If attempted, this method will respond with an invalid_scheduled_message_id error.
  step "pipeline" "delete_scheduled_message" {
    if         = !is_error(step.pipeline.schedule_message)
    depends_on = [step.pipeline.list_scheduled_messages]

    pipeline = pipeline.delete_scheduled_message
    args = {
      channel              = param.channel
      cred                 = param.cred
      scheduled_message_id = step.pipeline.schedule_message.output.schedule_message.scheduled_message_id
    }
  }

  output "channel" {
    description = "Channel name used in the test."
    value       = param.channel
  }

  output "schedule_message" {
    description = "Check for pipeline.schedule_message."
    value       = !is_error(step.pipeline.schedule_message) ? "pass" : "fail: ${step.pipeline.schedule_message.errors}"
  }

  output "list_scheduled_messages" {
    description = "Check for pipeline.list_scheduled_messages."
    value       = !is_error(step.pipeline.list_scheduled_messages) ? "pass" : "fail: ${step.pipeline.list_scheduled_messages.errors}"
  }

  output "delete_scheduled_message" {
    description = "Check for pipeline.delete_scheduled_message."
    value       = !is_error(step.pipeline.delete_scheduled_message) ? "pass" : "fail: ${step.pipeline.delete_scheduled_message.errors}"
  }
}
