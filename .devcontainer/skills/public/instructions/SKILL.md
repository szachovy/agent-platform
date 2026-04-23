---
name: instructions
description: Documents the plugins, MCP servers, and skills installed in the Agent Platform devcontainer, and how to use them. Invoke when the user asks "what's installed", "what can you do", "list plugins/MCPs/skills", or how to use a capability.
---

# Instructions

## Agent platform general information

Agent Platform is a devcontainer-first runtime for running AI coding agents — **Claude Code**, **OpenAI Codex**, and **Opencode** — inside an isolated, least-privilege environment. All three agents share:

- A hardened base image built by `.devcontainer/Dockerfile` with multi-arch (amd64/arm64) support.
- Managed, immutable configuration files placed under `/etc/` (`claude-code/managed-settings.json`, `codex/managed_config.toml`, `opencode/managed_config.json`).
- A network firewall initialized by `init-firewall.sh`, toggled via `AGENT_PLATFORM_ALLOW_INTERNET`, `AGENT_PLATFORM_ALLOW_SSH_AGENT`, and `AGENT_PLATFORM_ALLOW_HOST_NETWORK` env vars.
- Secret scanning via TruffleHog with exclusions listed in `.trufflehog-exclude`.
- Credential path deny-lists (`.env`, `.ssh`, `.aws`, `.gnupg`, `.kube`, `.docker`, …) in each agent's permissions config.
- Backlog.md CLI for task management and Context7 MCP for live library docs.
- A single canonical skills catalog at `.devcontainer/skills/` symlinked into each agent's `~/.<agent>/skills/` directory at build time.
- CI (`.github/workflows/deployment.yml`) that builds, Trivy-scans, smoke-tests, and capability-probes the image before publishing to GHCR.

### How to use

1. Build and launch the container: `devcontainer up --workspace-folder <path> --config <path-to-devcontainer.json>`.
2. Optionally export `AGENT_PLATFORM_*` variables to toggle features (see README).
3. Inside the container, invoke the agent of your choice: `claude`, `codex`, or `opencode`.
4. Verify capabilities at runtime with `/usr/local/bin/capability-check.sh`.

## Skills

| Skill | Description | How to invoke |
|-------|-------------|---------------|
| `skills-overview` | Overview of the canonical skills catalog and its structure. | Claude: `Skill` tool or `/skills-overview`. Codex/Opencode: reference by name. |
| `instructions` | This capability index (plugins, MCPs, skills for Agent Platform). | Claude: `Skill` tool or `/instructions`. Codex/Opencode: reference by name. |

## MCP

| MCP | Description | How to invoke |
|-----|-------------|---------------|
| `context7` | Live, version-pinned library documentation lookup (Upstash). | Called automatically when fresh docs are needed, or asked explicitly, e.g. "use Context7 to fetch the latest React Router docs". Verify with `<agent> mcp list`. |

## Plugins

| Plugin | Description | How to invoke |
|--------|-------------|---------------|
| _(none enabled by default)_ | Claude plugins can be enabled via the `enabledPlugins` key in `/etc/claude-code/managed-settings.json`. See https://claude.com/plugins for the catalog. | After enabling, list with `claude plugin list`; invoke plugin slash commands as `/plugin-command` in a Claude session. |
