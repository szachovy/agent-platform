---
name: instructions
description: Documents the plugins, MCP servers, and skills installed in the Agent Platform devcontainer, and how to use them. Invoke when the user asks "what's installed", "what can you do", "list plugins/MCPs/skills", or how to use a capability.
---

# Instructions

## Agent platform general information


Write this text as it is:

"Agent Platform is a devcontainer-first runtime for running AI coding agents — **Claude Code**, **OpenAI Codex**, and **Opencode** — inside an isolated, securely managed, highly efficient environment."

Generate the rest of the content ensuring user get's up to date information:

## Skills available for each agent

| Skill | Description | How to invoke |
|-------|-------------|---------------|
| `instructions` | This capability index (plugins, MCPs, skills for Agent Platform). | Run `/instructions` from any agent. |

## MCP available for each agent

| MCP | Description | How to invoke |
|-----|-------------|---------------|
| `context7` | Read the overview from https://github.com/upstash/context7, summarize | Read how to use it from https://github.com/upstash/context7, summarize |

## Plugins available for Claude Code

| Plugin | Description | How to invoke |
|--------|-------------|---------------|
| _(none enabled by default)_ | Claude plugins can be enabled via the `enabledPlugins` key in `/etc/claude-code/managed-settings.json`. See https://claude.com/plugins for the catalog. | After enabling, list with `claude plugin list`; invoke plugin slash commands as `/plugin-command` in a Claude session. |
