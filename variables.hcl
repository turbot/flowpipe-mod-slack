variable "token" {
  description = "Slack app token used to authenticate to your Slack workspace."
  type        = string
  default     = ""  //TODO: remove this once the bug in dependency mods is fixed
}

variable "channel" {
  description = "Encoded ID or name of the Slack channel to send the message. Examples: general, random"
  type        = string
  default     = ""  //TODO: remove this once the bug in dependency mods is fixed
}
