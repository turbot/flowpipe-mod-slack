# TODO: Should these have defaults?
# Right now they do due to :
# panic: missing 2 variable values:
# channel not set
# token not set

variable "token" {
  description = "Slack app token used to authenticate to your Slack workspace."
  type        = string
  default     = ""
}

variable "channel" {
  description = "Encoded ID or name of the Slack channel to send the message. Examples: general, random"
  type        = string
  default     = ""
}
