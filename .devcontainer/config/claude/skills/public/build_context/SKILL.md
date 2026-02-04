---
name: build-context
description: Gathers comprehensive context about a specific area of the codebase for future development. Use when preparing for feature implementation, major refactoring, or understanding complex subsystems.
---

# Build Context

This skill systematically explores a part of the codebase to build deep understanding before making changes.

## When to Use

- Before implementing a new feature in an unfamiliar area
- When planning a major refactoring
- When debugging complex issues that span multiple files
- When onboarding to a new codebase or subsystem

## Workflow

### 1. Identify Scope

- Clarify which part of the codebase to explore (specific module, feature, or subsystem)
- Ask user for starting points if unclear (entry files, key components)

### 2. Map the Structure

Use the Explore agent to:
- Find all relevant files using glob patterns
- Search for key functions, classes, and interfaces
- Identify dependencies and relationships between components
- Document the directory structure and organization

### 3. Analyze Key Files

For each critical file:
- Read and understand the main logic
- Note design patterns and architectural decisions
- Identify external dependencies and imports
- Document public APIs and interfaces

### 4. Trace Data Flow

- Follow how data moves through the system
- Identify state management patterns
- Note validation and transformation points
- Document side effects and I/O operations

### 5. Document Findings

Create a structured summary including:
- **Architecture overview**: High-level component relationships
- **Key files**: Purpose and responsibility of each major file
- **Patterns and conventions**: Coding styles and design patterns in use
- **Dependencies**: External libraries and internal module dependencies
- **Entry points**: Where to start implementing changes
- **Potential risks**: Areas that might be affected by changes

### 6. Save for Future Reference

- Store findings in a well-organized markdown document
- Include file paths with line references for important code sections
- Add ASCII diagrams for complex relationships if helpful

## Tool Usage

- **Task (Explore agent)**: For broad codebase exploration
- **Glob**: For finding specific file patterns
- **Grep**: For searching code patterns and keywords
- **Read**: For detailed file analysis
- **WebSearch**: For understanding unfamiliar libraries or patterns

## Output Format

Provide a markdown document structured as:

```markdown
# Context: [Subsystem Name]

## Overview
[High-level description of what this subsystem does]

## Architecture
[Component relationships, design patterns]

## Key Files
- [file.ts:123](path/to/file.ts#L123): [Purpose and key functions]

## Data Flow
[How data moves through the system]

## Dependencies
- External: [list libraries]
- Internal: [list modules]

## Implementation Notes
[Recommendations for making changes safely]
```
