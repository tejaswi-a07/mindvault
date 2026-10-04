# MindVault 🧠

> **Capture what matters. Remember what matters.**

MindVault is a premium personal knowledge, memory, idea, reflection, and note-management application built as a **genuine Flutter + Dart Material 3 app** for Android and Flutter Web. It is designed as a polished product/portfolio project rather than a basic CRUD notes demo.

## ✨ Product experience

- Premium indigo/violet visual language with lavender accents and warm light/dark surfaces.
- Rounded cards, subtle borders, polished typography, tasteful gradients, and responsive animations.
- Mobile uses Material 3 bottom navigation; tablet/desktop uses an extended navigation rail.
- Notes, ideas, tasks, reflections, moods, voice/photo placeholders, favorites, tags, search, filters, and sorting.
- Interactive **Memory Map** powered by Flutter `CustomPainter` with connected nodes and related notes.
- **Time Capsules** with future unlock dates, countdowns, and reveal state.
- **Mood Tracker** with daily entries and history visualization.
- Profile settings with theme switching, reset/clear data, and app analytics.
- Local persistence using `shared_preferences` so notes, moods, capsules, theme, and accent settings survive app restarts.

## 🚀 Run the Flutter app

### Prerequisites

- Flutter SDK 3.10+
- Dart 3+
- Android Studio or VS Code with Flutter/Dart extensions

### Install dependencies

```bash
flutter pub get
```

### Run on Android

```bash
flutter run
```

### Run on Flutter Web

```bash
flutter run -d chrome
```

## 🗂️ Project structure

```text
lib/
├── data/        # Seed/demo data
├── models/      # Note, mood, capsule, and memory-map models
├── providers/   # Shared app state + local persistence
├── screens/     # Home, Vault, Connect, Capsules, Mood, Search, Profile
├── theme/       # Material 3 light/dark design system
├── widgets/     # Reusable cards, dialogs, capture sheets, and graph widgets
└── main.dart    # Flutter entry point
web/             # Flutter Web bootstrap files
```

## 🧩 Architecture

MindVault uses Flutter widgets for UI, `Provider` for shared state, model classes for typed data, and `SharedPreferences` for lightweight local persistence. There is no React/Vite application in the project; the repository is intentionally Flutter-first.
