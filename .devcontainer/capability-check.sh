#!/bin/bash
#
# capability-check.sh <agent>
#
# Verifies that the MCP servers, plugins, and skills configured for a given
# agent (claude | codex | opencode) are visible and functional from the
# agent's own perspective. Designed to run inside the devcontainer image.
#
# Strategy: ask the agent, not the config file. A well-formed config does not
# prove the agent successfully loaded it, found the referenced binary, or
# connected to the server. We shell out to each agent's native list command
# and assert that every expected capability is present and healthy.
#
# Exits non-zero if any expected capability is missing or unhealthy.

set -o pipefail

agent="${1:-}"
if [[ -z "$agent" ]]; then
    echo "usage: capability-check.sh <claude|codex|opencode>" >&2
    exit 2
fi

failed=0

pass() { echo "PASS: $*"; }
skip() { echo "SKIP: $*"; }
fail() {
    echo "FAIL: $*"
    echo "::error title=Missing capability::$*"
    failed=1
}

strip_ansi() { sed -E 's/\x1b\[[0-9;]*[a-zA-Z]//g'; }

# ---------------------------------------------------------------------------
# Expected-capability manifest
#
# Keep this in sync with .devcontainer/config/<agent>/. A capability listed
# here but not visible to the agent produces a FAIL; a capability visible to
# the agent but not listed here is allowed (it does not block legitimate
# additions, but the expected set should be updated alongside the config).
# ---------------------------------------------------------------------------

EXPECTED_MCPS_CLAUDE=(context7)
EXPECTED_MCPS_CODEX=(context7)
EXPECTED_MCPS_OPENCODE=(context7)

EXPECTED_SKILLS_CLAUDE=(
    briefing
    login-to-remote-do-ops
    update-ruby-gems
    build_context
    explaining_code
    token-usage
)
EXPECTED_SKILLS_CODEX_PUBLIC=(build_context explaining_code token-usage)
EXPECTED_SKILLS_CODEX_PRIVATE=(briefing login-to-remote-do-ops update-documentation-section update-ruby-gems)

# Plugins land in a later task (TASK-140); for now we only assert that each
# agent's plugin subsystem responds, and emit a SKIP when the expected list
# is empty so silence never equals success.
EXPECTED_PLUGINS_CLAUDE=()
EXPECTED_PLUGINS_CODEX=()
EXPECTED_PLUGINS_OPENCODE=()

# ---------------------------------------------------------------------------
# Claude probes
# ---------------------------------------------------------------------------

check_claude_mcp() {
    local out
    if ! out=$(claude mcp list 2>&1 | strip_ansi); then
        fail "claude/mcp/list: command failed"
        return
    fi
    for name in "${EXPECTED_MCPS_CLAUDE[@]}"; do
        local line
        line=$(echo "$out" | grep -E "^${name}:" || true)
        if [[ -z "$line" ]]; then
            fail "claude/mcp/${name}: not visible to 'claude mcp list'"
            continue
        fi
        if echo "$line" | grep -qiE "connected|ok|enabled|authenticated"; then
            pass "claude/mcp/${name}: connected"
        elif echo "$line" | grep -qiE "needs authentication"; then
            pass "claude/mcp/${name}: visible (needs authentication)"
        else
            fail "claude/mcp/${name}: visible but unhealthy (${line})"
        fi
    done
}

check_claude_plugins() {
    if ! claude plugin list >/dev/null 2>&1; then
        fail "claude/plugin/list: command failed"
        return
    fi
    if [[ ${#EXPECTED_PLUGINS_CLAUDE[@]} -eq 0 ]]; then
        skip "claude/plugin: no expected plugins yet (tracked by TASK-140 / issue #16)"
        return
    fi
    local out
    out=$(claude plugin list 2>&1 | strip_ansi)
    for name in "${EXPECTED_PLUGINS_CLAUDE[@]}"; do
        if echo "$out" | grep -qE "(^|[[:space:]])${name}([[:space:]]|$)"; then
            pass "claude/plugin/${name}: installed"
        else
            fail "claude/plugin/${name}: not installed"
        fi
    done
}

check_claude_skills() {
    local skills_dir="${CLAUDE_CONFIG_DIR:-/home/node/.claude}/skills"
    if [[ ! -d "$skills_dir" ]]; then
        fail "claude/skill/_dir: ${skills_dir} does not exist"
        return
    fi
    for name in "${EXPECTED_SKILLS_CLAUDE[@]}"; do
        # Dockerfile flattens public/*/ and private/*/ into ~/.claude/skills/
        # via symlinks, so the runtime-visible path is ~/.claude/skills/<name>/SKILL.md.
        if [[ -f "${skills_dir}/${name}/SKILL.md" ]]; then
            pass "claude/skill/${name}: SKILL.md present"
        else
            fail "claude/skill/${name}: missing SKILL.md under ${skills_dir}"
        fi
    done
}

# ---------------------------------------------------------------------------
# Codex probes
# ---------------------------------------------------------------------------

check_codex_mcp() {
    local out
    if ! out=$(codex mcp list 2>&1 | strip_ansi); then
        fail "codex/mcp/list: command failed"
        return
    fi
    for name in "${EXPECTED_MCPS_CODEX[@]}"; do
        # Codex prints a table: Name  Command  Args  Env  Cwd  Status  Auth
        local row status
        row=$(echo "$out" | awk -v n="$name" '$1==n {print}')
        if [[ -z "$row" ]]; then
            fail "codex/mcp/${name}: not visible to 'codex mcp list'"
            continue
        fi
        status=$(echo "$row" | awk '{print $(NF-1)}')
        if [[ "$status" == "enabled" ]]; then
            pass "codex/mcp/${name}: enabled"
        else
            fail "codex/mcp/${name}: visible but status=${status}"
        fi
    done
}

check_codex_plugins() {
    # Codex exposes `codex plugin marketplace` but no "list installed" equivalent
    # today; the plugin subsystem is still a no-op for our repo until TASK-140.
    if ! codex plugin --help >/dev/null 2>&1; then
        fail "codex/plugin: subsystem unavailable"
        return
    fi
    if [[ ${#EXPECTED_PLUGINS_CODEX[@]} -eq 0 ]]; then
        skip "codex/plugin: no expected plugins yet (tracked by TASK-140 / issue #16)"
        return
    fi
    fail "codex/plugin: expected plugins set but codex has no 'plugin list' subcommand"
}

check_codex_skills() {
    local base="${CODEX_HOME:-/home/node/.codex}/skills"
    if [[ ! -d "$base" ]]; then
        fail "codex/skill/_dir: ${base} does not exist"
        return
    fi
    for name in "${EXPECTED_SKILLS_CODEX_PUBLIC[@]}"; do
        if [[ -f "${base}/public/${name}/SKILL.md" ]]; then
            pass "codex/skill/public/${name}: SKILL.md present"
        else
            fail "codex/skill/public/${name}: missing SKILL.md under ${base}/public"
        fi
    done
    for name in "${EXPECTED_SKILLS_CODEX_PRIVATE[@]}"; do
        if [[ -f "${base}/private/${name}/SKILL.md" ]]; then
            pass "codex/skill/private/${name}: SKILL.md present"
        else
            fail "codex/skill/private/${name}: missing SKILL.md under ${base}/private"
        fi
    done
}

# ---------------------------------------------------------------------------
# Opencode probes
# ---------------------------------------------------------------------------

check_opencode_mcp() {
    local out
    if ! out=$(opencode mcp list 2>&1 | strip_ansi); then
        fail "opencode/mcp/list: command failed"
        return
    fi
    for name in "${EXPECTED_MCPS_OPENCODE[@]}"; do
        # Opencode prints:  ●  ✓ <name> connected   \n      <command>
        if echo "$out" | grep -qE "[✓✗]\s+${name}\s+connected"; then
            pass "opencode/mcp/${name}: connected"
        elif echo "$out" | grep -qE "[[:space:]]${name}([[:space:]]|$)"; then
            fail "opencode/mcp/${name}: visible but not connected"
        else
            fail "opencode/mcp/${name}: not visible to 'opencode mcp list'"
        fi
    done
}

check_opencode_plugins() {
    # Opencode's `plugin` subcommand only installs; there's no "list installed"
    # command today. Once expected plugins are set (TASK-140), verify via the
    # merged config at runtime instead.
    if [[ ${#EXPECTED_PLUGINS_OPENCODE[@]} -eq 0 ]]; then
        skip "opencode/plugin: no 'list' subcommand; no expected plugins yet (TASK-140 / issue #16)"
        return
    fi
    fail "opencode/plugin: expected plugins set but opencode has no 'plugin list' subcommand"
}

check_opencode_skills() {
    # Opencode ships no on-disk skills directory in this repo.
    skip "opencode/skill: opencode has no on-disk skills directory in this repo"
}

# ---------------------------------------------------------------------------
# Dispatch
# ---------------------------------------------------------------------------

echo "=== capability-check: ${agent} ==="

case "$agent" in
    claude)
        check_claude_mcp
        check_claude_plugins
        check_claude_skills
        ;;
    codex)
        check_codex_mcp
        check_codex_plugins
        check_codex_skills
        ;;
    opencode)
        check_opencode_mcp
        check_opencode_plugins
        check_opencode_skills
        ;;
    *)
        fail "unknown agent: ${agent}"
        exit 2
        ;;
esac

echo "=== capability-check: ${agent} done (failed=${failed}) ==="
exit "$failed"
