# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Per-agent capability probe (`.devcontainer/capability-check.sh`) that verifies each configured MCP server, plugin, and skill is actually visible to Claude, Codex, and opencode at runtime. Expected MCPs/plugins are derived from the in-image managed configs; expected skills are derived from the repo's skills catalog at workflow time. Skill presence is now checked for all three agents.
- Trivy `CRITICAL`/`HIGH` findings now fail the pipeline (`exit-code: 1`) so vulnerable images cannot be published.

### Changed

- Consolidated the separate `ci-tests.yml` workflow into `deployment.yml`. Build, Trivy scan, smoke tests, and capability probe now run against the locally built image; images are exported as artifacts and pushed only by a separate `publish` job that runs after **every** matrix arch (amd64 and arm64) has passed. Multi-arch manifest and `:latest` promotion are published by the same job. Eliminates the `workflow_run` default-branch-only trigger gap and prevents untested or half-matrix images from being published.
- Tightened workflow permissions to per-job least privilege: top-level `contents: read`; `packages: write` scoped only to the `publish` job.
- Renamed workflow to `Build, Test, and Publish Agent Platform Devcontainer` to reflect its scope.

### Removed

- `ci-tests.yml` workflow (merged into `deployment.yml`).

## [Version 0.1]

### Added

- Context7 MCP server (by Upstash) for live, version-pinned library documentation — configured for Claude Code, Codex, and Opencode as the platform's first MCP server.
- Token usage monitoring skill for Claude Code and Codex agents — checks Anthropic/OpenAI usage via API or directs to web dashboards.
- ARM64 (Apple Silicon) devcontainer support: replaced Homebrew-based TruffleHog with direct binary download using Docker `TARGETARCH`.
- Multi-arch (amd64/arm64) builds and CI tests via QEMU emulation and matrix strategy.
- Trivy container image vulnerability scanning in the deployment workflow (`deployment.yml`).
- GitHub CI tests workflow (`ci-tests.yml`) for automated devcontainer smoke tests on pull requests.
- Backlog.md CLI installed globally for project task management, with documentation in CLAUDE.md and AGENTS.md.
- Opencode integrated as a third AI agent with managed config, persistent volume mount, and dedicated guidelines/tooling docs.

### Changed

- Switched Claude Code managed settings to `bypassPermissions` mode, dropped the top-level `defaultMode` and `disableBypassPermissionsMode` keys, and disabled the feedback survey via `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1`.
- Hardened managed settings for Claude Code and Codex: stricter permission defaults, credential path deny lists, forced login methods.
- Firewall script updated to dynamically toggle WebFetch/WebSearch and Codex network settings based on environment flags.
- Firewall and access checks extended for Opencode managed config permissions and internet-mode web permission toggles.
- TruffleHog exclusion list and access test script updated for broader coverage.
- Devcontainer configuration updated with Copilot extensions and volume mounts for persistent config.

### Fixed

- Access test SSH socket validation to skip VSCode SSH agent.

### PoC MVP

- Claude Code and Codex configuration, including:
  - Managed settings focused on non-exploitability.
  - Security rules.
  - Skills/tools and documentation for context management (Anthropic/OpenAI best practices).
- Access testing script to validate security constraints with supporting utilities and fixtures.
- Firewall initialization scripts for controlled ingress/egress with supporting files.
- Dockerfile and `devcontainer.json` for image deployment, installing Claude Code, Codex, GitHub Copilot, and related tooling.
- Project documentation (LICENSE, CONTRIBUTING, README, CHANGELOG, and architecture docs).
- Build scripts and GitHub workflows integration.

[Unreleased]: https://github.com/szachovy/agent-platform/compare/0.1...HEAD
[Version 0.1]: https://github.com/szachovy/agent-platform/releases/tag/0.1
