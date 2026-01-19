# Tools Reference

This document describes when and how to use Codex tools effectively.

## Task Management

### Plan (update_plan)

**Purpose**: Track progress on multi-step tasks and provide visibility to the user.

**When to use**:
- Tasks with 3+ distinct steps
- Non-trivial complex tasks requiring careful planning
- User explicitly requests progress tracking
- User provides multiple tasks (numbered or comma-separated)

**When NOT to use**:
- Single, straightforward tasks
- Trivial tasks completable in <3 steps
- Purely conversational/informational requests

**Best practices**:
- Create the plan at the start of complex work
- Mark one step as `in_progress` before starting (only one at a time)
- Mark steps as `completed` immediately after finishing each task

**Example**:
```json
{
  "plan": [
    {
      "step": "Update gem versions in Gemfile",
      "status": "in_progress"
    },
    {
      "step": "Verify compatibility with Ruby 3.3",
      "status": "pending"
    }
  ]
}
```

## Clarification

**Purpose**: Gather clarification, preferences, or decisions during execution.

**When to ask**:
- Requirements are ambiguous or unclear
- Multiple valid implementation approaches exist
- User preferences matter for design decisions

**Best practices**:
- Ask 1-4 concise questions at a time
- Provide 2-4 options when choices exist
- Keep wording short and concrete

## Planning Guidance

Use the plan tool for:
- New feature implementation with multiple approaches
- Code modifications affecting existing behavior
- Architectural decisions
- Multi-file changes (>2-3 files)

Avoid the plan tool for:
- Single-line or small fixes
- Very specific, detailed instructions provided
- Pure research/exploration tasks

## Tool Calling Patterns

### Parallel Execution

Call multiple independent tools in a single response when safe.

### Sequential Execution

Wait for results when tools depend on previous output.

### Never Use Placeholders

Always wait for real values; never guess parameters.

## Common Workflows

### Feature Implementation

1. Plan -> explore codebase as needed
2. Ask clarifying questions if required
3. Read existing code
4. Edit/write changes
5. Update plan statuses
6. Run tests when available

### Codebase Exploration

1. Find relevant files with search/glob
2. Read targeted files
3. Document findings

### Bug Investigation

1. Locate the issue area
2. Read suspected files
3. Ask clarifying questions about expected behavior
4. Implement the fix
5. Run tests when available
