# Agent Platform

Agent Platform is a devcontainer-based runtime for safely configuring and running AI agents in an isolated environment.

## Prerequisites

- Docker or a compatible container runtime.
- A devcontainer-capable environment (VS Code Dev Containers, `devcontainer` CLI, or compatible tooling).

## Deploying

Export configuration options _(optionally)_, then create and start the devcontainer environment.

```bash
export <configuration_option>=<value>
devcontainer up \
  --workspace-folder <workspace-path> \
  --config <path-to-devcontainer.json-file> \
  --build-no-cache
```

Sanity checks fails in case of security violations, but you can still use container by reloading the window.

## Configuration

Configuration is managed through environment variables.

| Variable | Default Value | Description | Required | Type |
| --- | --- | --- | --- | --- |
| `AGENT_PLATFORM_CLAUDE_CODE_VERSION` | `latest` | Devcontainer build arg that selects the Claude Code version. | No | String (version tag, e.g. `latest` or `1.2.3`) |
| `AGENT_PLATFORM_CODEX_VERSION` | `latest` | Devcontainer build arg that selects the Codex version. | No | String (version tag, e.g. `latest` or `1.2.3`) |
| `AGENT_PLATFORM_BACKLOG_MD_VERSION` | `latest` | Devcontainer build arg that selects the Backlog.md CLI version. | No | String (version tag, e.g. `latest` or `1.40.0`) |
| `AGENT_PLATFORM_ZSH_IN_DOCKER_VERSION` | `1.2.0` | Devcontainer build arg that selects the zsh-in-docker version. | No | String (version tag, e.g. `1.2.0`) |
| `AGENT_PLATFORM_ALLOW_INTERNET` | `true` | Allow internet access inside the devcontainer. | No | Boolean (`true`/`false`) |
| `AGENT_PLATFORM_ALLOW_SSH_AGENT` | `true` | Allow SSH agent forwarding into the devcontainer. | No | Boolean (`true`/`false`) |
| `AGENT_PLATFORM_ALLOW_HOST_NETWORK` | `true` | Allow host network access from the devcontainer. | No | Boolean (`true`/`false`) |
| `AGENT_PLATFORM_TZ` | `Europe/Warsaw` | Time zone for the devcontainer. | No | String (AGENT_PLATFORM_TZ database name, e.g. `Europe/Warsaw`) |

Options can be reapplied after the container is built by changing the options and restarting.

Currently, extension versions can’t be specified via environment variables in a devcontainer. Use the Extensions Manager to change them if necessary.

## References & Documentation

- [Architecture Overview](docs/architecture.md)
- [Anthropic Claude-Code devcontainer main](https://github.com/anthropics/claude-code/tree/main/.devcontainer)
- [Claude Code: Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices)
- [How to Safely Run AI Agents Like Cursor and Claude Code Inside a DevContainer](https://codewithandrea.com/articles/run-ai-agents-inside-devcontainer/)
- [Running codex cli in VS Code devcontainer](https://github.com/openai/codex/issues/2454)
- [Anthropic Claude-Code configuration reference](https://code.claude.com/docs/en/settings)
- [OpenAI Codex configuration reference](https://developers.openai.com/codex/config-reference)
- [Anthropic Claude-Code developer's guide](https://platform.claude.com/docs/en/home)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

See [LICENSE](LICENSE) for license information.
