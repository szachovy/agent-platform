# Tools Reference

This document describes when and how to use Claude's available tools effectively.

## Task Management Tools

### TodoWrite

**Purpose**: Track progress on multi-step tasks and provide visibility to the user.

**When to use**:
- Tasks with 3+ distinct steps
- Non-trivial complex tasks requiring careful planning
- User explicitly requests todo tracking
- User provides multiple tasks (numbered or comma-separated)

**When NOT to use**:
- Single, straightforward tasks
- Trivial tasks completable in <3 steps
- Purely conversational/informational requests

**Best practices**:
- Create todos at the start of complex work
- Mark as `in_progress` BEFORE starting work (only one at a time)
- Mark as `completed` IMMEDIATELY after finishing each task
- Each todo needs two forms:
  - `content`: Imperative (e.g., "Run tests")
  - `activeForm`: Present continuous (e.g., "Running tests")

**Example**:
```json
{
  "todos": [
    {
      "content": "Update gem versions in Gemfile",
      "activeForm": "Updating gem versions in Gemfile",
      "status": "in_progress"
    },
    {
      "content": "Verify compatibility with Ruby 3.3",
      "activeForm": "Verifying compatibility with Ruby 3.3",
      "status": "pending"
    }
  ]
}
```

## User Interaction Tools

### AskUserQuestion

**Purpose**: Gather clarification, preferences, or decisions during execution.

**When to use**:
- Requirements are ambiguous or unclear
- Multiple valid implementation approaches exist
- Need user preference on design decisions
- Offering choices about direction to take

**Best practices**:
- Ask 1-4 questions per call
- Provide 2-4 options per question
- Include clear descriptions for each option
- Use short headers (max 12 chars)
- Set `multiSelect: true` when choices aren't mutually exclusive
- Never ask "Is this plan okay?" (use ExitPlanMode instead)

**Example**:
```json
{
  "questions": [
    {
      "question": "Which testing framework should we use?",
      "header": "Test framework",
      "multiSelect": false,
      "options": [
        {
          "label": "Jest",
          "description": "Popular, fast, good for React projects"
        },
        {
          "label": "Vitest",
          "description": "Modern, Vite-native, faster cold starts"
        }
      ]
    }
  ]
}
```

## Planning Tools

### EnterPlanMode

**Purpose**: Transition to plan mode for designing implementation approach before coding.

**When to use**:
- New feature implementation with multiple approaches
- Code modifications affecting existing behavior
- Architectural decisions needed
- Multi-file changes (>2-3 files)
- Requirements need exploration first
- User preferences matter for implementation

**When NOT to use**:
- Single-line or small fixes
- Very specific, detailed instructions provided
- Pure research/exploration tasks (use Task tool instead)

**Best practices**:
- Use for non-trivial implementation tasks
- Better to plan too much than too little
- Users appreciate upfront alignment on approach

### ExitPlanMode

**Purpose**: Signal plan is complete and ready for user approval.

**When to use**:
- After writing comprehensive plan to plan file
- Plan exploration is complete and unambiguous
- Ready for user to review and approve

**Best practices**:
- Write plan to file BEFORE calling this tool
- Request prompt-based permissions for bash commands needed
- Scope permissions narrowly (e.g., "run read-only database queries")
- Don't use for research tasks (only for implementation planning)

## Tool Calling Patterns

### Parallel Execution

Call multiple independent tools in single response:
```
<tool_call: Read file1.ts>
<tool_call: Read file2.ts>
<tool_call: Read file3.ts>
```

### Sequential Execution

Wait for results when tools depend on previous output:
```
<tool_call: Grep "function name">
[wait for results]
<tool_call: Read specific_file.ts>
```

### Never Use Placeholders

Always wait for real values - never guess parameters:
```
❌ BAD: Read file at [LOCATION_FROM_PREVIOUS_TOOL]
✅ GOOD: Wait for grep results, then read actual file path
```

## Common Workflows

### Feature Implementation

1. EnterPlanMode → explore codebase
2. AskUserQuestion → clarify approach if needed
3. ExitPlanMode → get approval
4. TodoWrite → track implementation steps
5. Read → understand existing code
6. Edit/Write → make changes
7. TodoWrite → mark completed
8. Bash → run tests

### Codebase Exploration

1. Task (Explore agent) → broad understanding
2. Glob → find relevant files
3. Read → examine specific files
4. Document findings

### Bug Investigation

1. Task (Explore agent) → locate issue area
2. Read → examine suspected files
3. AskUserQuestion → clarify expected behavior
4. TodoWrite → track fix steps
5. Edit → implement fix
6. Bash → verify with tests
