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
    local agent="$1"
    local out
    case "$agent" in
        claude)   out=$(claude mcp list 2>&1 | strip_ansi) ;;
        codex)    out=$(codex mcp list 2>&1 | strip_ansi) ;;
        opencode) out=$(opencode mcp list 2>&1 | strip_ansi) ;;
    esac
    for name in "${EXPECTED_MCPS[@]}"; do
        if echo "$out" | grep -qi "$name"; then
            pass "${agent}/mcp/${name}"
        else
            fail "${agent}/mcp/${name}: not visible to '${agent} mcp list'"
        fi
    done
}

check_plugins() {
    local agent="$1"
    case "$agent" in
        claude)
            if ! claude plugin list >/dev/null 2>&1; then
                fail "${agent}/plugin: subsystem unavailable"
                return
            fi
            ;;
        codex)
            if ! codex plugin --help >/dev/null 2>&1; then
                fail "${agent}/plugin: subsystem unavailable"
                return
            fi
            ;;
        opencode)
            skip "${agent}/plugin: no list subcommand"
            return
            ;;
    esac
    if [[ ${#EXPECTED_PLUGINS[@]} -eq 0 ]]; then
        skip "${agent}/plugin: no expected plugins yet"
        return
    fi
    local out
    case "$agent" in
        claude) out=$(claude plugin list 2>&1 | strip_ansi) ;;
        codex)  out=$(codex plugin --help 2>&1 | strip_ansi) ;;
    esac
    for name in "${EXPECTED_PLUGINS[@]}"; do
        if echo "$out" | grep -qi "$name"; then
            pass "${agent}/plugin/${name}"
        else
            fail "${agent}/plugin/${name}: not installed"
        fi
    done
}

check_skills() {
    local agent="$1"
    local skills_dir
    case "$agent" in
        claude)   skills_dir="${CLAUDE_CONFIG_DIR:-/home/node/.claude}/skills" ;;
        codex)    skills_dir="${CODEX_HOME:-/home/node/.codex}/skills/public" ;;
        opencode)
            skip "${agent}/skill: no on-disk skills directory"
            return
            ;;
    esac
    if [[ ! -d "$skills_dir" ]]; then
        fail "${agent}/skill: ${skills_dir} does not exist"
        return
    fi
    for name in "${EXPECTED_SKILLS[@]}"; do
        if [[ -f "${skills_dir}/${name}/SKILL.md" ]]; then
            pass "${agent}/skill/${name}"
        else
            fail "${agent}/skill/${name}: missing SKILL.md under ${skills_dir}"
        fi
    done
}

echo "=== capability-check: ${agent} ==="
check_mcp "$agent"
check_plugins "$agent"
check_skills "$agent"
echo "=== capability-check: ${agent} done (failed=${failed}) ==="
exit "$failed"
