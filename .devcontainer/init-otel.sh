#!/bin/bash

set -euo pipefail

CLAUDE_MANAGED_SETTINGS="/etc/claude-code/managed-settings.json"

if [[ -z "${AGENT_PLATFORM_OTEL_ENDPOINT:-}" ]]; then
    echo "OpenTelemetry: no endpoint configured, skipping."
    exit 0
fi

echo "OpenTelemetry: configuring Claude Code telemetry..."

OTEL_ENV=$(jq -n \
    --arg endpoint "$AGENT_PLATFORM_OTEL_ENDPOINT" \
    --arg protocol "${AGENT_PLATFORM_OTEL_PROTOCOL:-grpc}" \
    --arg headers "${AGENT_PLATFORM_OTEL_HEADERS:-}" \
    '{
        "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
        "OTEL_METRICS_EXPORTER": "otlp",
        "OTEL_LOGS_EXPORTER": "otlp",
        "OTEL_EXPORTER_OTLP_PROTOCOL": $protocol,
        "OTEL_EXPORTER_OTLP_ENDPOINT": $endpoint
    } + (if $headers != "" then {"OTEL_EXPORTER_OTLP_HEADERS": $headers} else {} end)')

jq --argjson otel_env "$OTEL_ENV" '.env += $otel_env' "$CLAUDE_MANAGED_SETTINGS" | sponge "$CLAUDE_MANAGED_SETTINGS"

echo "OpenTelemetry: Claude Code configured with endpoint $AGENT_PLATFORM_OTEL_ENDPOINT (protocol: ${AGENT_PLATFORM_OTEL_PROTOCOL:-grpc})"
