# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Per-agent capability probe (`capability-check.sh`) verifying configured MCPs, plugins, and skills are visible to Claude, Codex, and opencode.
- Canonical `.devcontainer/config/shared/` catalog (`AGENTS.md`, `TOOLS.md`, `SECURITY.md`, `skills/`) distributed to all three agents by the Dockerfile build via symlinks; Claude receives `AGENTS.md` as `CLAUDE.md`, and `TOOLS.md`/`SECURITY.md` land in each agent's `rules/` directory.
- `instructions` public skill documenting installed plugins, MCP servers, and skills with invocation guidance.
- Five curated Claude plugins from the `claude-plugins-official` marketplace, pre-enabled via managed settings: `frontend-design`, `playwright`, `feature-dev`, `ralph-loop`, `context7`.
- System-wide Chromium (via apt) and `@playwright/mcp` (pinned by new `AGENT_PLATFORM_PLAYWRIGHT_MCP_VERSION` build arg) so the Playwright plugin has a usable browser. Dockerfile exports `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium` and `PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1` to skip runtime browser downloads.

### Changed

- Merged `ci-tests.yml` into `deployment.yml`: smoke tests and capability probe run against the locally built image before push; manifest job gated on all matrix arches passing.
- Scoped `packages: write` per job.
- Consolidated per-agent `config/<agent>/skills/` trees into a single source of truth; each agent's `~/.<agent>/skills/` is now a set of symlinks into the canonical catalog.
- `deployment.yml` now resolves `EXPECTED_SKILLS` from the canonical catalog.
- Slimmed the always-loaded agent root files to a short numbered behavioral preamble modeled on [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/CLAUDE.md) and deduplicated them into a single canonical `AGENTS.md` (plus canonical `TOOLS.md` and `SECURITY.md`) under `.devcontainer/config/shared/`, distributed to all three agents by the Dockerfile via symlinks. Inline security sections previously embedded in Codex and Opencode `AGENTS.md` were extracted into the canonical `SECURITY.md`.
- Claude receives Context7 via the `context7` plugin instead of the standalone `@upstash/context7-mcp` MCP server. Codex and Opencode continue to use the standalone MCP.

### Removed

- `ci-tests.yml` (merged into `deployment.yml`).
- Duplicated per-agent skill directories and agent-specific `SKILL.md` overview files under `config/claude/skills/` and `config/codex/skills/`.
- `build-context`, `explaining-code`, and `token-usage` public skills (superseded by the consolidated catalog).
- Per-agent `TOOLS.md` files at `.devcontainer/config/<agent>/TOOLS.md` and their follow-on per-agent `rules/tools.md` / `rules/security.md` copies — all replaced by the shared canonical catalog.
- `context7` entry from Claude's `managed-settings.json` `mcpServers` (the plugin now provides it). The entry remains for Codex and Opencode.

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
