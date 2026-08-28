# Contributing to Trainer Pro

Thanks for your interest in contributing. This document explains how to get started.

## Development Environment

1. **Install Flutter SDK** — Follow the [official install guide](https://docs.flutter.dev/get-started/install). Ensure you're on the stable channel.
2. **Clone the repo:**
   ```bash
   git clone https://github.com/<your-username>/trainerpro.git
   cd trainerpro
   ```
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```
4. **Set up Firebase:**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
   - Enable **Authentication** (Email/Password and Google providers).
   - Enable **Cloud Firestore**.
   - Download configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) and place them in the appropriate directories.
5. **Run the app:**
   ```bash
   flutter run
   ```

## Code Style

- Use `dart format` to format all Dart files before committing:
  ```bash
  dart format .
  ```
- Follow the [Dart style guide](https://dart.dev/effective-dart/style).
- The project uses `flutter_lints` via `analysis_options.yaml`. Ensure there are no analysis warnings:
  ```bash
  flutter analyze
  ```
- Prefer `final` and `const` where possible.
- Use meaningful variable and function names.
- Keep widgets small and focused. Extract reusable components into `lib/widgets/`.

## Branching and PRs

1. Create a feature branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Make your changes in small, focused commits.
3. Run `flutter analyze` and `dart format .` before pushing.
4. Open a pull request against `main` with:
   - A clear title describing the change.
   - A description of what changed and why.
   - Screenshots or recordings if the change is visual.
5. A maintainer will review your PR. Address any feedback promptly.

## Commit Conventions

Use clear, descriptive commit messages:

- `feat: add plate calculator dialog`
- `fix: correct timer reset on session end`
- `chore: update dependencies`
- `docs: add SECURITY.md`
- `refactor: extract chat widgets`

Prefixes: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`.

## Reporting Issues

Open an issue on GitHub with:
- Steps to reproduce.
- Expected vs. actual behavior.
- Flutter version (`flutter --version`).
- Device/emulator info.

## Code of Conduct

Be respectful and constructive in all interactions.
