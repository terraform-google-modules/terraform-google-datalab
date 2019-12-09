# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2019-12-09

### Changed

- Removed submodules `default_instance` and `gpu_instance` in favor of a single, backwards compatible, `instance` module. See `docs/upgrading_to_v1.0.md` for details. [#14]

## [0.3.0] - 2019-12-05

### Added

- The `labels` variables on the `gpu_instance` submodule and the `default_instance` submodule. [#7]

## [0.2.0] - 2019-11-12

### Added

- `create_fw_rule` variable to toggle creation of the firewall rule. [#4]
- `append_to_startup_script` variable to add additional, custom logic to the startup script. [#3]

## [0.1.0] - 2019-10-22

### Added

- Initial release

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-datalab/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/terraform-google-modules/terraform-google-datalab/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/terraform-google-modules/terraform-google-datalab/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/terraform-google-modules/terraform-google-datalab/releases/tag/v0.1.0

[#7]: https://github.com/terraform-google-modules/terraform-google-datalab/issues/7
[#4]: https://github.com/terraform-google-modules/terraform-google-datalab/issues/4
[#3]: https://github.com/terraform-google-modules/terraform-google-datalab/issues/3
