# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Playwright MCP (`claude`, `codex`, `opencode`) now launches the apt-installed `/usr/bin/chromium` headlessly via `--executable-path`/`--headless`, instead of falling back to its own separately-downloaded `chrome-for-testing` build (`--browser chromium` alone resolves to that channel internally). Removed the `xvfb` apt package and the unused `DISPLAY` env var, both dead weight since no Xvfb server was ever started.
- Backlog MCP (`backlog-md`) now gets an explicit `PWD=/workspace` env var so it correctly detects an already-initialized Backlog.md project instead of inheriting a stale `PWD` from the VS Code server process chain and reporting "not initialized".

## [Version 0.2]

### Added

- Per-agent capability probe (`capability-check.sh`) verifying configured MCPs, plugins, and skills are visible to Claude, Codex, and opencode.
- Canonical `.devcontainer/config/shared/` catalog (`AGENTS.md`, `TOOLS.md`, `SECURITY.md`, `skills/`) distributed to all three agents by the Dockerfile build via symlinks; Claude receives `AGENTS.md` as `CLAUDE.md`, and `TOOLS.md`/`SECURITY.md` land in each agent's `rules/` directory.
- Five curated Claude plugins from the `claude-plugins-official` marketplace, pre-enabled via managed settings: `frontend-design`, `playwright`, `feature-dev`, `ralph-loop`, `context7`.
- System-wide Chromium (via apt) and `@playwright/mcp` (pinned by new `AGENT_PLATFORM_PLAYWRIGHT_MCP_VERSION` build arg) so the Playwright plugin has a usable browser. Dockerfile exports `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium` and `PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1` to skip runtime browser downloads.
- `@radleta/backlog-md-mcp` MCP server (`backlog-md`) registered for Claude, Codex, and Opencode — exposes Backlog.md task/draft/doc/decision/board tools via typed MCP schemas so embedded CLI docs are no longer needed.
- `@beads/bd` CLI installed globally for all three agents (graph issue tracker / agentic memory system from https://github.com/gastownhall/beads); shell-capable agents use it directly per upstream guidance. New build args `AGENT_PLATFORM_BACKLOG_MD_MCP_VERSION` and `AGENT_PLATFORM_BEADS_VERSION`.
- `/etc/claude-code/managed-mcp.json` managed MCP config for Claude (the documented location for enterprise-deployed MCP servers). `claude mcp list` reads from this file, not from `mcpServers` in `managed-settings.json`.
- `OPENCODE_CONFIG=/etc/opencode/managed_config.json` exported as a container-wide environment variable so the managed Opencode config is picked up under bash (capability-check) as well as zsh (interactive sessions).
- `AGENT_PLATFORM_TRUFFLEHOG_VERSION` build arg to pin a specific TruffleHog release. Defaults to `latest` (existing API-driven behavior); when set to a tag (e.g. `3.95.2`), the build skips the GitHub API call and pulls the pinned release directly.
- `@playwright/mcp` MCP server registered for Codex and Opencode managed configs (Claude gets it via the `playwright` plugin).
- "How to use it" section in README linking to the [wiki](https://github.com/szachovy/agent-platform/wiki/How-to-use-agent%E2%80%90platform).
- VS Code `1.121.0` devcontainer workspace-folder bug warning and symlink workaround documented in README.

### Changed

- Merged `ci-tests.yml` into `deployment.yml`: smoke tests and capability probe run against the locally built image before push; manifest job gated on all matrix arches passing.
- Scoped `packages: write` per job.
- Consolidated per-agent `config/<agent>/skills/` trees into a single source of truth; each agent's `~/.<agent>/skills/` is now a set of symlinks into the canonical catalog.
- `deployment.yml` now resolves `EXPECTED_SKILLS` from the canonical catalog.
- Slimmed the always-loaded agent root files to a short numbered behavioral preamble modeled on [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/CLAUDE.md) and deduplicated them into a single canonical `AGENTS.md` (plus canonical `TOOLS.md` and `SECURITY.md`) under `.devcontainer/config/shared/`, distributed to all three agents by the Dockerfile via symlinks. Inline security sections previously embedded in Codex and Opencode `AGENTS.md` were extracted into the canonical `SECURITY.md`.
- Claude receives Context7 via the `context7` plugin instead of the standalone `@upstash/context7-mcp` MCP server. Codex and Opencode continue to use the standalone MCP.
- Backlog.md integration moved from per-agent CLI + embedded markdown instructions to a dedicated `backlog-md` MCP server.
- Credential path deny lists added to Codex `managed_config.toml` filesystem permissions (`.env*`, `.pem`, `.key`, `.crt`, `.ssh/`, `.aws/`, `.azure/`, `.config/gcloud/`, `.gnupg/`, `.kube/`, `.docker/`).
- Re-enabled plugin hooks in Claude Code managed settings by removing empty hook arrays and the `allowManagedHooksOnly` restriction.
- `docs/architecture.md` updated to reflect the shared catalog structure, consolidated per-agent config directories, and merged CI workflow.
- README configuration table expanded with new build args (`AGENT_PLATFORM_BACKLOG_MD_MCP_VERSION`, `AGENT_PLATFORM_BEADS_VERSION`, `AGENT_PLATFORM_PLAYWRIGHT_MCP_VERSION`, `AGENT_PLATFORM_TRUFFLEHOG_VERSION`).
- `.gitignore` updated to reference the shared skills directory (`config/shared/skills/private/`) instead of per-agent paths.

### Fixed

- Stale symlink issues in Dockerfile setup for shared config distribution.

### Removed

- `ci-tests.yml` (merged into `deployment.yml`).
- Duplicated per-agent skill directories and agent-specific `SKILL.md` overview files under `config/claude/skills/` and `config/codex/skills/`.
- `build-context`, `explaining-code`, and `token-usage` public skills (superseded by the consolidated catalog).
- Per-agent `CLAUDE.md`, `AGENTS.md`, and `TOOLS.md` root files and their follow-on per-agent `rules/tools.md` / `rules/security.md` copies — all replaced by the shared canonical catalog.
- `context7` entry from Claude's `managed-settings.json` `mcpServers` (the plugin now provides it). The entry remains for Codex and Opencode.
- `statsig.anthropic.com` from the firewall allowlist — the domain no longer resolves; `statsig.com` covers Statsig traffic.
- `instructions` public skill — replaced by the [How to use it wiki](https://github.com/szachovy/agent-platform/wiki/How-to-use-agent%E2%80%90platform).

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

[Unreleased]: https://github.com/szachovy/agent-platform/compare/0.2...HEAD
[Version 0.2]: https://github.com/szachovy/agent-platform/releases/tag/0.2
[Version 0.1]: https://github.com/szachovy/agent-platform/releases/tag/0.1
