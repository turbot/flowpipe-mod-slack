variable "token" {
  description = "Slack app token used to authenticate to your Slack workspace."
  # TODO: Add once supported
  #sensitive  = true
  type        = string
  default     = ""  // TODO: remove this once the bug in dependency mods is fixed
}

variable "channel" {
  description = "Encoded ID or name of the Slack channel to send the message. Encoded ID is recommended. Examples: C1234567890, general, random"
  # TODO: Add once supported
  #sensitive  = true
  type        = string
  default     = ""  // TODO: remove this once the bug in dependency mods is fixed
}
