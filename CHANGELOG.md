# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Per-agent capability probe (`capability-check.sh`) verifying configured MCPs, plugins, and skills are visible to Claude, Codex, and opencode.

### Changed

- Merged `ci-tests.yml` into `deployment.yml`: smoke tests and capability probe run against the locally built image before push; manifest job gated on all matrix arches passing.
- Scoped `packages: write` per job.

### Removed

- `ci-tests.yml` (merged into `deployment.yml`).

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
