# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Claude Code and Codex configuration, including:
  - Managed settings focused on non-exploitability.
  - Security rules.
  - Skills/tools and documentation for context management (Anthropic/OpenAI best practices).
- Access testing script to validate security constraints with supporting utilities and fixtures.
- Firewall initialization scripts for controlled ingress/egress with supporting files.
- Dockerfile and `devcontainer.json` for image deployment, installing Claude Code, Codex, GitHub Copilot, and related tooling.
- Project documentation (LICENSE, CONTRIBUTING, README, CHANGELOG, and architecture docs).
- Build scripts and GitHub workflows integration.
