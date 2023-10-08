variable "slack_token" {
  description = "Slack Bot token"
  type        = string
  default     = null
}

variable "channel" {
  description = "Encoded ID or name of the slack channel to send the message. Example: general"
  type        = string
  default     = "test-build-slack-room"
}

variable "message" {
  description = "Text message to send to the slack channel."
  type        = string
  default     = "Hello from Flowpipe slack mod"
}
