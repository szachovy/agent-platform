---
name: explaining-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
---

# Explaining Code

This skill provides clear, pedagogical explanations of code using multiple learning aids.

## When to Use

- User asks "how does this work?" or "explain this code"
- Teaching about a codebase or system architecture
- Clarifying complex algorithms or design patterns
- Onboarding new developers to existing code

## Workflow

### 1. Start with Context

Provide a brief overview:
- What does this code do at a high level?
- Where does it fit in the larger system?
- Why might it be implemented this way?

### 2. Use an Analogy

Compare the code to something from everyday life:
- Good: "This cache works like a librarian's desk - frequently requested books stay close at hand"
- Avoid: "This implements a least-recently-used eviction policy"

For complex concepts, use multiple analogies showing different aspects.

### 3. Draw a Diagram

Use ASCII art to visualize:
- Data flow through functions
- Component relationships
- State transitions
- Call hierarchies

Example:
```
User Request -> Validator -> Cache -> Database
                   |          |         |
                 Error     Hit/Miss   Query
```

### 4. Walk Through Step-by-Step

Explain the code execution:
- Number each step clearly (1, 2, 3...)
- Describe what happens, not just what the code says
- Highlight important decisions or branches
- Note side effects and state changes

### 5. Highlight Key Concepts

Point out:
- Design patterns in use
- Performance considerations
- Error handling strategies
- Edge cases being handled

### 6. Connect to Best Practices

Relate to broader principles:
- Why is this approach good (or problematic)?
- What alternatives exist?
- When would you use a different approach?

## Style Guidelines

- Keep explanations conversational and approachable
- Avoid jargon unless it's essential (then define it)
- Use concrete examples over abstract descriptions
- Build from simple to complex concepts
- Check understanding by explaining the "why" not just the "what"

## Example Structure

```markdown
## What This Code Does
[High-level purpose in one sentence]

## Real-World Analogy
[Everyday comparison that captures the essence]

## How It Works
[ASCII diagram showing the flow]

## Step-by-Step Walkthrough
1. [First action with why it matters]
2. [Second action with context]
...

## Key Concepts
- [Pattern or principle with explanation]

## Why It's Built This Way
[Trade-offs and design decisions]
```
