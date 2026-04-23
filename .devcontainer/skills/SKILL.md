---
name: skills-overview
description: Overview of the canonical skills catalog, shared across all agents (Claude, Codex, Opencode).
---

# Skills Overview

Skills are specialized capabilities that help agents handle specific types of tasks more effectively. Each skill defines a focused workflow with clear instructions.

This catalog is the single source of truth for skills across Claude, Codex, and Opencode. It is distributed to each agent's skill directory by the devcontainer build.

## Skills Catalog Structure

```bash
skills/
├── public/    # Committed to the repository, available to all team members.
└── private/   # Local only, excluded via `.gitignore`, for personal workflows.
```

## Available Skills

### Public Skills (`skills/public/`)

- **instructions**: Documents installed plugins, MCP servers, and skills and how to use them.
