# Trainer Pro

![Dart](https://img.shields.io/badge/language-Dart-0175C2)
![Framework](https://img.shields.io/badge/framework-Flutter-02569B)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)
![Database](https://img.shields.io/badge/database-Firestore-FFCA28)
![Status](https://img.shields.io/badge/status-in%20development-yellow)
![License](https://img.shields.io/badge/license-MIT-green)

AI-powered fitness tracking app for serious lifters.

Trainer Pro is a Flutter application that helps users log workouts, track progress over time, and get AI-generated coaching advice through a Gemini-powered chatbot. Data is synced to Firebase Cloud Firestore for cloud backup and multi-device access.

---

## Table of contents

- [Features](#features)
- [Tech stack](#tech-stack)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Build](#build)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Training sessions** — Log workouts with sets, reps, weight, and notes. Supports custom exercise templates and weekly planning.
- **Exercise database** — Built-in library of exercises with the ability to add custom entries.
- **Rest timer** — Configurable countdown timer with audio alerts, draggable overlay, and background persistence.
- **Progress tracking** — Charts (via `fl_chart`) showing volume, weight, and estimated 1RM over time. Filterable by exercise and date range.
- **AI chatbot** — Gemini-powered conversational assistant for form tips, programming advice, and motivation. Supports multiple conversations.
- **Plate calculator** — Quick tool to calculate plate combinations for a target weight.
- **Firebase Auth** — Email/password registration with verification, plus Google Sign-In.
- **Cloud sync** — Workout history and user data synced to Firestore with strict security rules.
- **Multiple themes** — Five built-in dark themes (Deep Slate, Cyber Neon, Crimson Blood, Toxic Green, Solar Flare) with persistent selection.
- **Notifications** — Local notifications for timer alerts.

---

## Tech stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x / Dart 3.10+ |
| State | StatefulWidget with manual state management |
| Auth | Firebase Auth, Google Sign-In |
| Database | Cloud Firestore |
| AI | Google Gemini API |
| Charts | fl_chart |
| Icons | Lucide Icons, Cupertino Icons |
| Audio | audioplayers |
| Local storage | SharedPreferences |
| Notifications | flutter_local_notifications |

---

## Architecture

```
lib/
├── main.dart                  # App entry point, Firebase init
├── app.dart                   # MaterialApp, auth routing, theme switching
├── models/
│   ├── training_session.dart  # Training session data model
│   └── exercise_set.dart      # Individual exercise set model
├── screens/
│   ├── main_screen.dart       # Primary screen with tab navigation
│   └── auth_screen.dart       # Login / registration screen
├── theme/
│   └── app_theme.dart         # Theme enum definitions
└── widgets/
    ├── plate_calculator_dialog.dart  # Plate calculator UI
    └── animated_widgets.dart         # Reusable animated components
```

---

## Prerequisites

- Flutter SDK 3.x (channel stable)
- Dart SDK >= 3.10.4
- A Firebase project with Auth and Firestore enabled
- A Gemini API key (optional, for chatbot features)

---

## Installation

```bash
# Clone the repository
git clone https://github.com/<your-username>/trainerpro.git
cd trainerpro

# Install dependencies
flutter pub get

# Configure Firebase (if not already set up)
# Place your google-services.json in android/app/
# Place your GoogleService-Info.plist in ios/Runner/
# Or run: flutterfire configure

# Run the app
flutter run
```

---

## Build

```bash
# Android APK (release)
flutter build apk --release

# Android App Bundle (release)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## Security

- Firestore rules enforce per-user document access only.
- Sensitive fields (`uid`, `role`, `isAdmin`, `email`) are immutable after creation.
- Email verification is required before account access is granted.
- Input sanitization on user-provided data.
- API keys are not committed to version control.

See [SECURITY.md](SECURITY.md) for details.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
