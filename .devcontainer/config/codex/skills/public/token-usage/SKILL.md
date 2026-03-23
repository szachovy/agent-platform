---
name: token-usage
description: Shows current API token usage, remaining quota, and percentages. Use when the user wants to check how many tokens they've consumed, their remaining budget, or usage breakdown by model.
---

# Token Usage Monitoring

This skill helps users understand their current API token consumption across AI providers.

## When to Use

- User asks "how many tokens have I used?"
- User wants to check remaining quota or budget
- User wants a usage breakdown by model
- Before deciding on token-saving strategies

## Workflow

### 1. Check for API Keys

Check which API keys are available in the environment:

```bash
# Check for OpenAI API key
echo "OPENAI_API_KEY: ${OPENAI_API_KEY:+set}"
# Check for Anthropic Admin API key
echo "ANTHROPIC_ADMIN_API_KEY: ${ANTHROPIC_ADMIN_API_KEY:+set}"
```

### 2. Retrieve Usage Data

#### OpenAI (Codex)

**If `OPENAI_API_KEY` is set**, direct the user to the usage dashboard:

> Check your OpenAI token usage at:
> - **API users**: https://platform.openai.com/usage
> - **ChatGPT Pro/Team subscribers**: https://chatgpt.com/codex/settings/usage

**If no key is available**:

> No `OPENAI_API_KEY` found. Check your OpenAI usage at:
> - **API users**: https://platform.openai.com/usage
> - **ChatGPT Pro/Team subscribers**: https://chatgpt.com/codex/settings/usage

#### Anthropic (Claude)

**If `ANTHROPIC_ADMIN_API_KEY` is set**, query the Usage API for the current billing period (last 30 days):

```bash
curl -s "https://api.anthropic.com/v1/organizations/usage_report/messages?\
starting_at=$(date -u -d '30 days ago' +%Y-%m-%dT00:00:00Z)&\
ending_at=$(date -u +%Y-%m-%dT23:59:59Z)&\
group_by[]=model&\
bucket_width=1d" \
  --header "anthropic-version: 2023-06-01" \
  --header "x-api-key: $ANTHROPIC_ADMIN_API_KEY"
```

Parse the response and sum token counts per model (input_tokens, output_tokens, cache_creation_input_tokens, cache_read_input_tokens).

**If no Admin API key is available**, direct the user to check usage manually:

> No `ANTHROPIC_ADMIN_API_KEY` found. Check your Anthropic token usage at:
> - **Claude Pro/Team subscribers**: https://claude.ai/settings/usage
> - **API users**: https://console.anthropic.com/settings/usage

### 3. Format Output

When API data is available, present it as a table:

```
Provider: Anthropic
Period: 2026-02-23 to 2026-03-23

Model                  | Input Tokens | Output Tokens | Total Tokens
-----------------------|--------------|---------------|-------------
claude-opus-4-6        |    1,234,567 |       456,789 |    1,691,356
claude-sonnet-4-6      |      890,123 |       234,567 |    1,124,690
claude-haiku-4-5       |    2,345,678 |       678,901 |    3,024,579
-----------------------|--------------|---------------|-------------
Total                  |    4,470,368 |     1,370,257 |    5,840,625
```

### 4. Provide Context

After showing the data, briefly note:
- Current pricing per model (input/output per million tokens)
- Estimated cost based on usage
- Tips if usage is high (prompt caching, batching, using smaller models for simple tasks)

## Important Notes

- The Anthropic Usage API requires an **Admin API key** (`sk-ant-admin...`), not a regular API key
- OpenAI programmatic usage access requires organization-level API permissions
- Usage data is typically available within 5 minutes of API request completion
