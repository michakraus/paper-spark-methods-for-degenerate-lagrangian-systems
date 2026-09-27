# Changelog

All notable changes to SparkMethodsForDegenerateLagrangianSystems.jl are recorded here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

This record starts with this file. The repository has earlier history: releases v0.1.0, v0.1.1,
v0.1.2, v0.2.0 and v0.3.0 have no entries here.

**When a measured number changes, the entry says why** — a fix, a dependency bump, a different
tolerance, a different machine. A results table that silently differs from last month's is the
failure this prevents.

## [Unreleased]

### Added

- **Coverage is uploaded to Codecov** from the `min` Linux job; there was no coverage before.
  `codecov.yml` sets the project and patch checks to a 1 % threshold.
- **Dependabot opens the `[compat]` bumps**, weekly, and ignores the standard libraries.

### Changed

- **CI runs the shared workflow of the other experiment and package repositories.** The test matrix
  is Julia `min` (the `[compat] julia` floor, 1.10) and `1` on Linux, macOS and Windows, with
  `pre` and `nightly` as advisory jobs. The pinned `1.10` gives way to `min`, and the job names
  change with it, so the required checks of branch protection can be one fixed list across all
  repositories. The test job's timeout is 120 minutes, where it was 60. A new
  `Doctests - ubuntu-latest` job skips itself here, because the repository has no
  `docs/Project.toml`.
- **The documentation workflow is `Documenter.yml`**, formerly `Documentation.yaml`. The weave
  pipeline is unchanged; only the action versions move to the current majors. The comment in
  `docs/Makefile` names the new file.

### Removed

- **Known issue K2**, the doubt that the `[sources]` entry in `test/Project.toml` works on
  Julia 1.10. CI run 36306710864 at `a16fc8d` answers it: the three Julia 1.10 jobs pass, on Linux,
  macOS and Windows.
