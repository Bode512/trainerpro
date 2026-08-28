# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 2.0.x   | Yes       |
| < 2.0   | No        |

Only the latest release receives security patches.

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **Do not** open a public GitHub issue.
2. Email the maintainers or use GitHub's private vulnerability reporting feature.
3. Include:
   - A description of the vulnerability.
   - Steps to reproduce.
   - Potential impact.
   - Suggested fix (if any).

You will receive an acknowledgment within 72 hours. We will work with you to understand and address the issue before any public disclosure.

## Security Measures

### Authentication
- Firebase Authentication with email/password and Google Sign-In.
- Email verification is enforced before granting account access.
- Accounts with unverified emails are signed out immediately.

### Firestore Rules
- Default deny-all policy on all documents.
- Users can only read and write their own `users/{userId}` document.
- Sensitive fields (`uid`, `role`, `isAdmin`, `email`) are protected from modification after creation.
- Document creation requires `email` and `createdAt` fields.

### Input Validation
- Email format validation using regex.
- Blocked email domain list (configurable).
- Password minimum length enforcement (6 characters).
- User display name sanitization (strips `<` and `>` characters).

### Data Protection
- API keys are not hardcoded in version-controlled files.
- `google-services.json` and `GoogleService-Info.plist` are excluded from the repository via `.gitignore`.
- Local data is stored in `SharedPreferences` (device-only).

### Network
- All Firebase communication uses HTTPS.
- Gemini API calls go over HTTPS via the `http` package.

## Best Practices for Contributors

- Never commit secrets, API keys, or credentials.
- Do not disable or weaken Firestore rules without discussion.
- Use parameterized queries — never concatenate user input into Firestore queries.
- Follow the principle of least privilege.
