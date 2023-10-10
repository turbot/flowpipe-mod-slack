---
repository: "https://github.com/turbot/flowpipe-mod-slack"
---

# Flowpipe Slack Mod

Run pipelines and use triggers for Slack resources.

## References

[Slack](https://slack.com/) is a messaging program designed specifically for the workplace.

[Flowpipe](https://flowpipe.io) is an open source workflow tool.

[Flowpipe Mods](https://flowpipe.io/docs/reference/mod-resources#mod) are collections of `pipelines` and `triggers`.

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/slack/pipelines)**
- **[Triggers →](https://hub.flowpipe.io/mods/turbot/slack/triggers)**

## Getting started

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-mod-slack.git
cd flowpipe-mod-slack
```

### Usage

Start your server to get started:

```sh
flowpipe service start
```

Run a pipeline:

```sh
flowpipe pipeline run chat_post_message
```

### Credentials

This mod uses the credentials configured in `flowpipe.pvars` or passed through `--pipeline-args token`.

### Configuration

Pipelines have [input variables](https://flowpipe.io/docs/using-flowpipe/mod-variables) that can be configured to better match your environment and requirements. Some variables have defaults defined in its source file, e.g., `variables.hcl`, but these can be overwritten in several ways:

- Copy and rename the `flowpipe.pvars.example` file to `flowpipe.pvars`, and then modify the variable values inside that file
- Pass in a value on the command line:

  ```shell
  flowpipe pipeline run chat_post_message --pipeline-arg token="xoxp-12345-67890"
  ```

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://flowpipe.io/docs/using-flowpipe/mod-variables#passing-input-variables).

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/flowpipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://flowpipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/flowpipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/flowpipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/flowpipe-mod-slack/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [GitHub Mod](https://github.com/turbot/flowpipe-mod-slack/labels/help%20wanted)
