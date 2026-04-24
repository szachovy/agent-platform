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
| `context7` | Upstash Context7 — live, version-specific library documentation lookup (https://github.com/upstash/context7). On Claude, surfaced via the `context7` plugin (see table below). On Codex and Opencode, surfaced via the standalone `@upstash/context7-mcp` MCP server. | Read how to use it from https://github.com/upstash/context7, summarize. |

## Plugins available for Claude Code

| Plugin | Description | How to invoke |
|--------|-------------|---------------|
| `frontend-design@claude-plugins-official` | Production-grade frontend generation (Anthropic-managed). See https://claude.com/plugins/frontend-design. | Use plugin skills/agents from a Claude session; `claude plugin list` confirms installation. |
| `playwright@claude-plugins-official` | Browser automation and end-to-end testing MCP server by Microsoft. Uses the system `chromium` binary at `/usr/bin/chromium` via `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH`. | Use plugin tools for browser automation. See https://claude.com/plugins/playwright. |
| `feature-dev@claude-plugins-official` | Feature development workflow with explore / design / review agents (Anthropic-managed). | Invoke the bundled agents or skills from a Claude session. See https://claude.com/plugins/feature-dev. |
| `ralph-loop@claude-plugins-official` | Iterative "Ralph Wiggum" loop for long-running tasks (Anthropic-managed). | Invoke the loop skill from a Claude session. See https://claude.com/plugins/ralph-loop. |
| `context7@claude-plugins-official` | Upstash Context7 plugin for live, version-specific library documentation lookup. Replaces the standalone Context7 MCP on Claude. | Invoke the plugin's skill / MCP tools from a Claude session. See https://claude.com/plugins/context7. |
