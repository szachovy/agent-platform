# Architecture

Agent Platform is a devcontainer-first runtime for configuring and running AI agents inside a constrained environment. It defaults to a least-privilege stance with explicit, opt-in toggles for internet access, host networking, and SSH agent forwarding.

## Key components

- Devcontainer build and runtime definitions for repeatable setup.
- Agent configuration for Claude Code, OpenAI Codex, and Opencode with managed settings, skills, MCPs and plugins.
- Security constraints, firewall defaults, and secret scanning exclusions.
- CI workflow to build and publish the container image.

## Project structure

```
.
|-- .devcontainer
|   |-- Dockerfile -> Base image and build steps for the devcontainer.
|   |-- access.sh -> Runtime access test setup for the container.
|   |-- config
|   |   |-- claude
|   |   |   |-- managed-settings.json -> Managed (immutable) settings applied to Claude.
|   |   |   `-- managed-mcp.json -> Managed (immutable) MCP server definitions for Claude (deployed to /etc/claude-code/).
|   |   |-- codex
|   |   |   `-- managed_config.toml -> Managed (immutable) Codex configuration.
|   |   |-- opencode
|   |   |   `-- managed_config.json -> Managed (immutable) Opencode configuration.
|   |   `-- shared -> Canonical catalog distributed to all agents at build time via symlinks.
|   |       |-- AGENTS.md -> Behavioral guidelines (symlinked into each agent's home; renamed to CLAUDE.md for Claude).
|   |       |-- TOOLS.md -> Tool usage guidance (symlinked to `rules/tools.md` in each agent's home).
|   |       |-- SECURITY.md -> Security rules (symlinked to `rules/security.md` in each agent's home).
|   |       `-- skills -> Skills catalog (skill dirs symlinked into each agent's `skills/`).
|   |           |-- private -> Private skills (not visible in git).
|   |           `-- public -> Public skills (visible in git), including the `instructions` skill.
|   |-- devcontainer.json -> Main devcontainer definition file.
|   |-- init-firewall.sh -> Initializes container ingress/egress rules.
|   |-- sudoers -> Sudo policy overrides for the container.
|   `-- trufflehog-exclude -> Patterns excluded from secret filesystem and env scanning.
|-- .github
|   `-- workflows
|       `-- deployment.yml -> Builds, scans, smoke-tests, and publishes the devcontainer image via GitHub Actions.
|-- .gitignore -> Files and directories ignored by Git.
|-- .pre-commit-config.yaml -> Pre-commit hooks for local checks.
|-- CHANGELOG.md -> Notable changes by release.
|-- CONTRIBUTING.md -> Contribution workflow and guidelines.
|-- LICENSE -> Project license.
`-- README.md -> Project overview and usage instructions.
```
