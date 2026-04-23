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
|   |   |   |-- CLAUDE.md -> Claude agent usage and constraints.
|   |   |   |-- TOOLS.md -> Tool usage guidance for Claude.
|   |   |   |-- managed-settings.json -> Managed (immutable) settings applied to Claude.
|   |   |   `-- rules
|   |   |       `-- security.md -> Claude security rules and constraints.
|   |   |-- codex
|   |   |   |-- AGENTS.md -> Codex agent behavior and policies.
|   |   |   |-- TOOLS.md -> Tool usage guidance for Codex.
|   |   |   `-- managed_config.toml -> Managed (immutable) Codex configuration.
|   |   `-- opencode
|   |       |-- AGENTS.md -> Opencode agent behavior and policies.
|   |       |-- TOOLS.md -> Tool usage guidance for Opencode.
|   |       `-- managed_config.json -> Managed (immutable) Opencode configuration.
|   |-- skills -> Canonical skills catalog distributed to all agents at build time.
|   |   |-- SKILL.md -> Catalog overview.
|   |   |-- private -> Private skills (not visible in git).
|   |   `-- public -> Public skills (visible in git), including the `instructions` skill.
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
