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

- **Coverage is uploaded to Codecov** from the `1` Linux job; there was no coverage before.
  `codecov.yml` sets the project and patch checks to a 1 % threshold.
- **Dependabot opens the `[compat]` bumps**, weekly, for the root `Project.toml` only, and ignores
  the standard libraries.
- **An advisory `Downgrade - ubuntu-latest` job tests the `[compat]` lower bounds.** It resolves
  each direct dependency of the root `Project.toml` to its lower bound on the lowest Julia and runs
  the suite there. It is not a required check.

### Changed

- **A CI test job saves the Julia cache only when it succeeds.**
- **`test/Project.toml` no longer repeats the root's `[compat]` bounds.** Its `GeometricIntegrators`
  and `GeometricProblems` entries are removed: a dependency of the root `Project.toml` takes its
  bound from the root only, so the test environment resolves exactly what users resolve.
- **Two `[compat]` floors rise so that every floor resolves together on Julia 1.10.**
  GeometricIntegrators is `"0.18.1"`, in `Project.toml`: 0.18.0 requires
  GeometricIntegratorsBase 0.5 and SimpleSolvers 0.10, below the floors 0.6 and 0.11. Weave is
  `"0.10.11"`: up to 0.10.10 it caps Highlights at 0.4, and so DocStringExtensions at 0.8, while
  GeometricProblems 0.8.3 needs DocStringExtensions 0.9 through Symbolics 7. Compat-only; no
  behaviour changes.
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
