---
name: skills-overview
description: Overview of the skills catalog structure and usage for this repository.
---

# Skills Overview

Skills are specialized capabilities that help Codex handle specific types of tasks more effectively. Each skill defines a focused workflow with clear instructions.

## Skills Catalog Structure

Skills are organized into two catalogs:

```
skills/
├── public/    # Shared with the team (committed to git)
└── private/   # Personal skills (gitignored)
```

- **Public skills**: Committed to the repository, available to all team members
- **Private skills**: Local only, excluded via `.gitignore`, for personal workflows

## Available Skills

### Public Skills (`skills/public/`)

- **build-context**: Gathers comprehensive context about a specific area of the codebase for future development. Use when preparing for feature implementation, major refactoring, or understanding complex subsystems.
- **explaining-code**: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
- **token-usage**: Shows current API token usage, remaining quota, and percentages. Use when the user wants to check how many tokens they've consumed, their remaining budget, or usage breakdown by model.

### Private Skills (`skills/private/`)

Private skills are not listed here - check your local `skills/private/` directory.

## Using Skills

Skills are invoked using the Skill tool. Each skill has:
- **name**: The skill identifier used to invoke it
- **description**: When and why to use this skill
- **instructions**: Step-by-step workflow the skill follows

## Creating New Skills

When creating a new skill:

1. Define a clear, specific purpose (not "general coding help")
2. Include frontmatter with name and description
3. Write actionable, imperative instructions
4. Specify when to use specialized tools (web search, planning, etc.)
5. Define expected outputs or deliverables
6. Keep skills focused on a single workflow

## Skill Best Practices

- **Be specific**: "Search web for latest docs" not "Research if needed"
- **Use structure**: Numbered steps for sequential workflows
- **Avoid redundancy**: Don't duplicate instructions from AGENTS.md
- **Scope clearly**: Define what the skill does and doesn't do
- **Test iteratively**: Update based on actual usage patterns
