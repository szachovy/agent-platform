---
name: instructions
description: Documents the plugins, MCP servers, and skills installed in the Agent Platform devcontainer, and how to use them. Invoke when the user asks "what's installed", "what can you do", "list plugins/MCPs/skills", or how to use a capability.
---

# Instructions

This skill is the user-facing index of capabilities available in the Agent Platform devcontainer. Use it to answer questions about what plugins, MCP servers, and skills are installed and how to use each.

## When to Use

- User asks what's available (plugins, MCPs, skills, slash commands).
- User asks how to invoke or configure a specific capability.
- User is onboarding to the Agent Platform and needs a tour.

## Plugins

Plugins extend agent CLIs with additional behaviors. The Agent Platform ships with no third-party plugins enabled by default; Claude plugins are managed via `managed-settings.json`. See https://claude.com/plugins for the full catalog of Claude plugins and installation instructions.

### How to use Claude plugins

1. List enabled plugins: `claude plugin list`.
2. Enable/disable is controlled by the managed `enabledPlugins` setting in `/etc/claude-code/managed-settings.json` (immutable at runtime).
3. Invoke plugin-provided slash commands as `/plugin-command` in a Claude session.

## MCP Servers

Model Context Protocol (MCP) servers give agents access to external tools and data sources over a standard protocol.

### Installed

- **context7** (by Upstash) — Live, version-pinned library documentation lookup.
  - Invocation: agents call it automatically when they need up-to-date library docs; you can also ask explicitly, e.g. "use Context7 to fetch the latest React Router docs".
  - Config:
    - Claude: `/etc/claude-code/managed-settings.json` → `mcpServers.context7`.
    - Codex: `/etc/codex/managed_config.toml` → `[mcp_servers.context7]`.
    - Opencode: `/etc/opencode/managed_config.json` → `mcp.context7`.

### How to verify MCPs at runtime

- Claude: `claude mcp list`.
- Codex: `codex mcp list`.
- Opencode: `opencode mcp list`.

## Skills

Skills are focused workflows distributed to each agent from the canonical catalog at `.devcontainer/config/skills/`. They are available to all three agents (Claude, Codex, Opencode).

### Public skills

- **skills-overview** — Overview of the canonical skills catalog.
- **build-context** — Gather comprehensive context about a codebase area before feature work or refactoring.
- **explaining-code** — Explain code with diagrams and analogies.
- **token-usage** — Report API token usage, remaining quota, and per-model breakdown.
- **instructions** — This skill.

### Private skills

Listed only in your local `skills/private/` directory (gitignored). Typical examples: `briefing`, `login-to-remote-do-ops`, `update-ruby-gems`.

### How to invoke a skill

- **Claude Code**: Use the `Skill` tool or type `/<skill-name>` as a slash command when the skill is surfaced.
- **Codex**: Reference the skill by name; Codex reads `SKILL.md` files from `~/.codex/skills/`.
- **Opencode**: Skills live under `~/.config/opencode/skills/`; invoke via slash command `/<skill-name>` in the TUI.

## Slash Commands

Common slash commands exposed by the installed skills/plugins:

| Command | Skill / Plugin | Purpose |
|---------|----------------|---------|
| `/instructions` | instructions | Show this capability index. |
| `/skills-overview` | skills-overview | Show the skills catalog overview. |
| `/build-context` | build-context | Start a structured codebase exploration. |
| `/explaining-code` | explaining-code | Explain code with diagrams. |
| `/token-usage` | token-usage | Show API token usage. |

Availability of slash commands depends on the agent CLI. Use `/help` in-session to see the effective list.

## Output Format

When invoked, respond with a concise, sectioned summary of Plugins, MCPs, and Skills, tailored to what the user asked for. If the user asked about a specific capability, focus on that one and include concrete invocation steps.

## References

- Claude plugin catalog: https://claude.com/plugins
- Claude Code settings: https://code.claude.com/docs/en/settings
- Codex config: https://developers.openai.com/codex/config-reference
- Opencode config: https://opencode.ai/docs/config/
- Model Context Protocol: https://modelcontextprotocol.io
