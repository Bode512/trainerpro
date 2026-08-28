# Changelog

All notable changes to Trainer Pro are documented here.

## [2.0.0+2] - 2025

### Added
- Firebase Authentication with email/password and Google Sign-In.
- Email verification flow for new accounts.
- Gemini AI chatbot with multi-conversation support.
- Rest timer with background persistence and audio alerts.
- Cloud Firestore sync for user data.
- Firestore security rules with per-user document access.
- Local notifications for timer alerts.

### Changed
- Migrated from local-only storage to cloud-backed Firestore.

## [2.0.0+3] - 2025

### Added
- Security audit and hardening of Firestore rules.
- Background timer persistence across app lifecycle events.
- Custom app icon.
- Input sanitization on user-provided data.

### Fixed
- Timer reset behavior on session end.
- Auth state handling on app restart.
