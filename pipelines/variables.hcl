variable "slack_token" {
  description = "Slack Bot token"
  type        = string
  default     = null
}

variable "slack_channel_name" {
  description = "Name of the slack channel to send the message. Example: general"
  type = string
  default = "random"
}

variable "slack_message" {
  description = "Text message to send to the slack channel."
  type = string
  default = "Hello from Flowpipe slack mod"
}