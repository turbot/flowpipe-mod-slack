# Slack Mod for Flowpipe

Slack pipeline library for [Flowpipe](https://flowpipe.io), enabling seamless integration of Slack services into your workflows.

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/slack/pipelines)**

## Getting started

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

### Credentials

By default, the following environment variables will be used for authentication:

- `SLACK_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/slack.fpc
```

```hcl
credential "slack" "default" {
  token = "xoxp-12345-..."
}

credential "slack" "workspace_2" {
  token = "xoxp-67890-..."
}
```

For more information on credentials, please see:

- [Managing Credentials](https://flowpipe.io/docs/run/credentials)
- [Slack Credentials](https://flowpipe.io/docs/reference/config-files/credential/slack)

### Usage

[Initialize a mod](https://flowpipe.io/docs/build#initializing-a-mod)::

```sh
mkdir my_mod
cd my_mod
flowpipe mod init
```

[Install the Slack mod](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies) as a dependency:

```sh
flowpipe mod install github.com/turbot/flowpipe-mod-slack
```

[Use the dependency](https://flowpipe.io/docs/build/write-pipelines) in a pipeline step:

```sh
vi my_pipeline.fp
```

```hcl
pipeline "my_pipeline" {

  param "cred" {
    type        = string
    description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    args = {
      cred    = param.cred
      channel = "test"
      text    = "Hello World"
    }
  }
}
```

[Run the pipeline](https://flowpipe.io/docs/run/pipelines):

```sh
flowpipe pipeline run my_pipeline
```

To use a specific `credential`, specify the `cred` pipeline argument:

```sh
flowpipe pipeline run my_pipeline --arg cred=workspace_2
```

### Developing

Clone:

```sh
git clone https://github.com/turbot/flowpipe-mod-slack.git
cd flowpipe-mod-slack
```

List pipelines:

```sh
flowpipe pipeline list
```

Run a pipeline:

```shell
flowpipe pipeline run post_message --arg channel=test --arg text="Hello World"
```

To use a specific `credential`, specify the `cred` pipeline argument:

```sh
flowpipe pipeline run post_message --arg channel=test --arg text="Hello World" --arg cred=workspace_2
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Slack Mod](https://github.com/turbot/flowpipe-mod-slack/labels/help%20wanted)
