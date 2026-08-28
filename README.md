# Trainer Pro

**AI-powered fitness tracking app for serious lifters.**

Trainer Pro is a Flutter application that helps users log workouts, track progress over time, and get AI-generated coaching advice through a Gemini-powered chatbot. Data is synced to Firebase Cloud Firestore for cloud backup and multi-device access.

---

## Features

- **Training Sessions** — Log workouts with sets, reps, weight, and notes. Supports custom exercise templates and weekly planning.
- **Exercise Database** — Built-in library of exercises with the ability to add custom entries.
- **Rest Timer** — Configurable countdown timer with audio alerts, draggable overlay, and background persistence.
- **Progress Tracking** — Charts (via `fl_chart`) showing volume, weight, and estimated 1RM over time. Filterable by exercise and date range.
- **AI Chatbot** — Gemini-powered conversational assistant for form tips, programming advice, and motivation. Supports multiple conversations.
- **Plate Calculator** — Quick tool to calculate plate combinations for a target weight.
- **Firebase Auth** — Email/password registration with verification, plus Google Sign-In.
- **Cloud Sync** — Workout history and user data synced to Firestore with strict security rules.
- **Multiple Themes** — Five built-in dark themes (Deep Slate, Cyber Neon, Crimson Blood, Toxic Green, Solar Flare) with persistent selection.
- **Notifications** — Local notifications for timer alerts.

## Tech Stack

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
| Local Storage | SharedPreferences |
| Notifications | flutter_local_notifications |

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

## Prerequisites

- Flutter SDK 3.x (channel stable)
- Dart SDK >= 3.10.4
- A Firebase project with Auth and Firestore enabled
- A Gemini API key (optional, for chatbot features)

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

## Build

```bash
# Android APK (release)
flutter build apk --release

# Android App Bundle (release)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Security

- Firestore rules enforce per-user document access only.
- Sensitive fields (`uid`, `role`, `isAdmin`, `email`) are immutable after creation.
- Email verification is required before account access is granted.
- Input sanitization on user-provided data.
- API keys are not committed to version control.

See [SECURITY.md](SECURITY.md) for details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
