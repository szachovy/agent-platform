#!/bin/bash

set -o pipefail

expected_mcp_claude="$(jq -r '.mcpServers // {} | keys | join(" ")' /etc/claude-code/managed-settings.json)"
expected_plugins_claude="$(jq -r '(.enabledPlugins // .plugins // {}) | keys | join(" ")' /etc/claude-code/managed-settings.json)"
expected_mcp_codex="$(grep -oE '^\[mcp_servers\.[^]]+\]' /etc/codex/managed_config.toml | sed -E 's/^\[mcp_servers\.(.+)\]$/\1/' | paste -sd' ')"
expected_mcp_opencode="$(jq -r '.mcp // {} | keys | join(" ")' /etc/opencode/managed_config.json)"

rc=0

check_agent_skills_mcp_plugins() {
    for name in $(eval echo "\$expected_mcp_${1}"); do
        if "$1" mcp list 2>&1 | grep -qi "$name"; then
            echo "PASS: ${1} mcp ${name} available"
        else
            echo "FAIL: ${1} mcp ${name} not available"
            rc=1
        fi
    done

    if [[ "$1" == "claude" ]]; then
        for name in ${expected_plugins_claude}; do
            if claude plugin list 2>&1 | grep -qi "$name"; then
                echo "PASS: ${1} plugin ${name} available"
            else
                echo "FAIL: ${1} plugin ${name} not available"
                rc=1
            fi
        done
    fi

    [[ "$1" == "opencode" ]] && return
    for name in ${EXPECTED_SKILLS}; do
        if [[ -f "/home/node/.${1}/skills/${name}/SKILL.md" ]]; then
            echo "PASS: ${1} skill ${name} available"
        else
            echo "FAIL: ${1} skill ${name} not available"
            rc=1
        fi
    done
}

check_agent_skills_mcp_plugins claude
check_agent_skills_mcp_plugins codex
check_agent_skills_mcp_plugins opencode
exit "$rc"
