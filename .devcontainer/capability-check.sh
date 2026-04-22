#!/bin/bash

set -o pipefail

agent="$1"
failed=0

pass() { echo "PASS: $*"; }
skip() { echo "SKIP: $*"; }
fail() {
    echo "FAIL: $*"
    echo "::error title=Missing capability::$*"
    failed=1
}

strip_ansi() { sed -E 's/\x1b\[[0-9;]*[a-zA-Z]//g'; }

EXPECTED_MCPS=(context7)
EXPECTED_SKILLS=(build_context explaining_code token-usage)
EXPECTED_PLUGINS=()

check_mcp() {
    local out
    out=$("$1" mcp list 2>&1 | strip_ansi)
    for name in "${EXPECTED_MCPS[@]}"; do
        if echo "$out" | grep -qi "$name"; then
            pass "$1/mcp/${name}"
        else
            fail "$1/mcp/${name}"
        fi
    done
}

check_plugins() {
    if [[ "$1" != "claude" ]]; then
        skip "$1/plugin: only checked for claude"
        return
    fi
    local out
    out=$(claude plugin list 2>&1 | strip_ansi)
    if [[ ${#EXPECTED_PLUGINS[@]} -eq 0 ]]; then
        skip "$1/plugin: no expected plugins yet"
        return
    fi
    for name in "${EXPECTED_PLUGINS[@]}"; do
        if echo "$out" | grep -qi "$name"; then
            pass "$1/plugin/${name}"
        else
            fail "$1/plugin/${name}"
        fi
    done
}

check_skills() {
    local skills_dir
    case "$1" in
        claude)   skills_dir="${CLAUDE_CONFIG_DIR:-/home/node/.claude}/skills" ;;
        codex)    skills_dir="${CODEX_HOME:-/home/node/.codex}/skills/public" ;;
        opencode) skip "$1/skill: no on-disk skills directory"; return ;;
    esac
    for name in "${EXPECTED_SKILLS[@]}"; do
        if [[ -f "${skills_dir}/${name}/SKILL.md" ]]; then
            pass "$1/skill/${name}"
        else
            fail "$1/skill/${name}"
        fi
    done
}

echo "=== capability-check: ${agent} ==="
check_mcp "$agent"
check_plugins "$agent"
check_skills "$agent"
echo "=== capability-check: ${agent} done (failed=${failed}) ==="
exit "$failed"
