## v1.0.0 (2024-10-22)

_Breaking changes_

- Flowpipe `v1.0.0` is now required. For a full list of CLI changes, please see the [Flowpipe v1.0.0 CHANGELOG](https://flowpipe.io/changelog/flowpipe-cli-v1-0-0).
- In Flowpipe configuration files (`.fpc`), `credential` and `credential_import` resources have been renamed to `connection` and `connection_import` respectively.
- Renamed all `cred` params to `conn` and updated their types from `string` to `conn`.

_Enhancements_

- Added `library` to the mod's categories.
- Updated the following pipeline tags:
  - `type = "featured"` to `recommended = "true"`
  - `type = "test"` to `folder = "Tests"`

## v0.3.0 [2024-09-20]

_Enhancements_

- Added an optional param `blocks` to the `post_message` pipeline. ([#24](https://github.com/turbot/flowpipe-mod-slack/pull/24)) (Thanks [@johnlayton](https://github.com/johnlayton) for the contribution!)

## v0.2.1 [2024-02-28]

_Bug fixes_

- Fixed the type mismatch of the input parameter in the `get_channel_history` pipeline. ([#20](https://github.com/turbot/flowpipe-mod-slack/pull/20))

## v0.2.0 [2024-02-07]

_What's new?_

- Added pipeline `get_channel_id`. ([#17](https://github.com/turbot/flowpipe-mod-slack/pull/17)).

_Bug fixes_

- Fixed the input parameters of the `test_post_message` pipeline. ([#17](https://github.com/turbot/flowpipe-mod-slack/pull/17))

## v0.1.0 [2023-12-14]

_What's new?_

- Added 15+ pipelines to make it easy to connect your Channel, Chat, User resources and more. For usage information and a full list of pipelines, please see [Slack Mod for Flowpipe](https://hub.flowpipe.io/mods/turbot/slack).
