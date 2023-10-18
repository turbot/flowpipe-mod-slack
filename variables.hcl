variable "token" {
  description = "Slack app token used to authenticate to your Slack workspace."
  type        = string
}

variable "channel" {
  description = "Encoded ID or name of the Slack channel to send the message. Examples: general, random"
  type        = string
}
