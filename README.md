# MindVault 🧠

> *"Capture what matters. Remember what matters."*

MindVault is a premium personal knowledge, memory, idea, reflection, and note-management Flutter application built with **Material 3**. Designed for College UDF (UI Design using Flutter) curriculum and product portfolios.

---

## 🚀 How to Run

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.10.0)
- Android Studio / VS Code with Flutter & Dart extensions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run on Android Emulator or Physical Device
```bash
flutter run
```

### 3. Run on Flutter Web (Chrome)
```bash
flutter run -d chrome
```

---

## 📱 Features

1. **Dashboard & Quick Capture**:
   - Greeting & search bar
   - 6 Quick capture modes: 📝 Note, 💡 Idea, ☑ Task, 😊 Mood, 🎙 Voice memo, 📷 Photo
   - Real-time animated stats (Memories, Ideas, Reflections, Favorites, Capsules)
   - Today's Reflection & nostalgic "On This Day" card
   - Recent Memories list

2. **The Vault**:
   - Filter chips by category (`All`, `Personal`, `Study`, `Ideas`, `Work`, `Travel`, `Goals`)
   - Real-time search by keyword, title, tag, or content
   - Sort by Newest, Oldest, A–Z Alphabetical, and Most Loved (Favorites)
   - Note options sheet on long-press (Edit, Favorite, Delete with confirmation dialog)

3. **Your Mind (Interactive Memory Map)**:
   - Visual knowledge graph built with `CustomPainter`
   - Bézier connection curves and glowing active states
   - Tappable nodes that highlight linked nodes and reveal related notes below

4. **Time Capsules**:
   - Sealed messages for your future self with countdown day trackers
   - Unlocked demo capsule with celebratory reveal dialog
   - Create new capsules with future date picker

5. **Mood Tracker**:
   - Daily mood selector (😊 Happy, 😌 Calm, 🔥 Motivated, 🤔 Curious, 😔 Sad, 😡 Frustrated)
   - Reflection logger
   - Weekly mood history visualization

6. **Search**:
   - Search across title, content, category, and tags
   - Related topic chips
   - Custom empty state ("Nothing surfaced.")

7. **Profile & Material 3 Dark Mode**:
   - Light, Dark, and System theme switching
   - Space analytics & storage manager
   - Reset demo data & Export JSON

8. **Responsive Layout**:
   - Mobile: Bottom `NavigationBar`, single column, floating action button
   - Tablet / Desktop / Web: `NavigationRail` sidebar with header branding and responsive `GridView`
