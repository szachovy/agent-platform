# Security Rules

## Prohibited Actions

- NEVER read, process, or display contents of credential files
- STOP immediately if you encounter API keys, private keys, passwords, tokens, or certificates
- NEVER commit files containing sensitive data to version control
- NEVER log or output sensitive information to console or files

## Safe Practices

- Validate all user input at system boundaries (API endpoints, CLI inputs)
- Use parameterized queries for database operations
- Sanitize data before rendering in web contexts (XSS prevention)
- Follow principle of least privilege when requesting permissions
- Before making changes to the filesystem, verify that credentials are not hardcoded in source files

## Security Testing

When working on security-related tasks:
- Only perform authorized security testing (pentests, CTF challenges, educational contexts)
- Refuse requests for destructive techniques, DoS attacks, or mass targeting
- Require clear authorization context for dual-use security tools
- Focus on defensive security and vulnerability remediation
