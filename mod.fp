mod "slack" {
  title         = "Slack"
  description   = "Run pipelines to supercharge your Slack workflows using Flowpipe."
  color         = "#7C2852"
  documentation = file("./README.md")
  icon          = "/images/flowpipe/mods/turbot/slack.svg"
  categories    = ["library", "messaging"]

  opengraph {
    title       = "Slack Mod for Flowpipe"
    description = "Run pipelines to supercharge your Slack workflows using Flowpipe."
    image       = "/images/mods/turbot/slack-social-graphic.png"
  }

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}
