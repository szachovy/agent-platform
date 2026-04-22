---
name: skills-overview
description: Overview of the canonical skills catalog, shared across all agents (Claude, Codex, Opencode).
---

# Skills Overview

Skills are specialized capabilities that help agents handle specific types of tasks more effectively. Each skill defines a focused workflow with clear instructions.

This catalog is the single source of truth for skills across Claude, Codex, and Opencode. It is distributed to each agent's skill directory by the devcontainer build.

## Skills Catalog Structure

```
skills/
├── public/    # Shared with the team (committed to git)
└── private/   # Personal skills (gitignored)
```

- **Public skills**: Committed to the repository, available to all team members.
- **Private skills**: Local only, excluded via `.gitignore`, for personal workflows.

## Available Skills

### Public Skills (`skills/public/`)

- **build-context**: Gathers comprehensive context about a specific area of the codebase.
- **explaining-code**: Explains code with visual diagrams and analogies.
- **token-usage**: Shows current API token usage, remaining quota, and usage breakdown.
- **instructions**: Documents installed plugins, MCP servers, and skills and how to use them.

### Private Skills (`skills/private/`)

Private skills are not listed here - check your local `skills/private/` directory.

## Using Skills

Each skill has:
- **name**: The skill identifier used to invoke it.
- **description**: When and why to use this skill.
- **instructions**: Step-by-step workflow the skill follows.

Agents invoke skills via their respective mechanisms (e.g. the `Skill` tool in Claude Code, slash commands in Opencode, or equivalent in Codex).

## Creating New Skills

1. Define a clear, specific purpose (not "general coding help").
2. Add frontmatter with `name` and `description`.
3. Write actionable, imperative instructions that are agent-neutral where possible.
4. Specify when to use specialized tools (web search, exploration agents, etc.).
5. Define expected outputs or deliverables.
6. Keep skills focused on a single workflow.
7. **Choose the right catalog**:
   - `public/` for team-shared workflows.
   - `private/` for personal or experimental skills.

## Skill Best Practices

- **Be specific**: "Search web for latest docs" not "Research if needed".
- **Use structure**: Numbered steps for sequential workflows.
- **Avoid redundancy**: Don't duplicate instructions from `CLAUDE.md` / `AGENTS.md`.
- **Scope clearly**: Define what the skill does and doesn't do.
- **Stay agent-neutral**: Prefer generic tool names (e.g. "web search") over agent-specific ones where it doesn't change meaning.
