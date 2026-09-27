# Changelog

All notable changes to SparkMethodsForDegenerateLagrangianSystems.jl are recorded here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

This repository begins with this file, so there is no history predating it and nothing has been
reconstructed from `git log`.

**When a measured number changes, the entry says why** — a fix, a dependency bump, a different
tolerance, a different machine. A results table that silently differs from last month's is the
failure this prevents.

## [Unreleased]

### Changed

- **CI runs the shared workflow of the other experiment and package repositories.** The test matrix
  is Julia `min` (the `[compat] julia` floor, 1.10) and `1` on Linux, macOS and Windows, with
  `pre` and `nightly` as advisory jobs. The pinned `1.10` gives way to `min`, and the job names
  change with it, so the required checks of branch protection can be one fixed list across all
  repositories. The test job's timeout is 120 minutes, where it was 60.
- **Coverage is uploaded to Codecov** from the `min` Linux job; there was no coverage before.
  `codecov.yml` sets the project and patch checks to a 1 % threshold.
- **The documentation workflow is `Documenter.yml`**, formerly `Documentation.yaml`. The weave
  pipeline is unchanged; only the action versions move to the current majors.
- **Dependabot opens the `[compat]` bumps**, weekly, and ignores the standard libraries.
