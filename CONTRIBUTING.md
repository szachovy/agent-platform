# Contributing to Agent Platform

Thank you for your interest in contributing to the Agent Platform.

## How to contribute

1. Fork the repository and create a feature branch.
2. Make changes on your local branch and follow the [Development Guidelines](#development-guidelines).
3. (Optional) Run `pre-commit run --all-files` if you have pre-commit installed.
4. Push the changes, open a Pull Request, and request review from `@szachovy`.
5. Once CI passes and the changes are approved, the PR will be merged into `master`.

## Development Guidelines

- The goal of this project is to provide a safe, isolated environment for running AI agents. Security is the top priority (least privilege, no experimental options, etc.).
- The project should work on any OS and backend, do not pin configuration to specific technologies (for example, WSL2).
- Assume no extra options will be set on the host OS beyond the basic setup.
- Do not prioritize any agent. Keep Claude Code, Codex, and Opencode configuration and documentation aligned.
- For structural changes, update the [Architecture](docs/architecture.md) documentation.
- Always add an entry to [`CHANGELOG.md`](./CHANGELOG.md) following its conventions.
- Code is MIT-licensed; do not introduce dependencies that require subscriptions or are closed source.

## Questions?

Open an issue or reach out to the maintainers.
