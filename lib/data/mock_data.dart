import '../models/note.dart';
import '../models/mood.dart';
import '../models/capsule.dart';
import '../models/connection.dart';

class MockData {
  static List<Note> getInitialNotes() {
    final now = DateTime.now();
    return [
      Note(
        id: 'note-1',
        title: 'Flutter UDF Project Architecture',
        content: 'Building MindVault with Material 3 design principles. Focusing on seamless responsive layout transitions using LayoutBuilder and NavigationRail for desktop/web, while preserving bottom navigation on Android phones. CustomPainter provides the interactive node visualization for knowledge mapping.',
        category: 'Study',
        mood: '🔥',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        isFavorite: true,
        tags: ['Flutter', 'Dart', 'Material3', 'Architecture'],
        type: 'idea',
      ),
      Note(
        id: 'note-2',
        title: 'DBMS Revision - Normalization & B+ Trees',
        content: 'Quick review for database engineering exams:\n- 1NF: Atomic values, unique column names\n- 2NF: 1NF + no partial dependency on candidate key\n- 3NF: 2NF + no transitive dependencies (X -> Y, Y -> Z)\n- BCNF: Strict 3NF where every determinant is a super key\nRemember: B+ trees store all records in leaf nodes with doubly linked lists for fast range scans.',
        category: 'Study',
        mood: '🤔',
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 5)),
        isFavorite: false,
        tags: ['DBMS', 'Exams', 'ComputerScience', 'SQL'],
        type: 'note',
      ),
      Note(
        id: 'note-3',
        title: 'Summer Internship Goals 2026',
        content: 'Targeting mobile engineering or full-stack software development roles. Preparing system design fundamentals, building production-grade Flutter apps with smooth 60fps animations, polishing GitHub profile, and practicing LeetCode medium dynamic programming patterns.',
        category: 'Goals',
        mood: '🔥',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        isFavorite: true,
        tags: ['Career', 'Internship', 'Resume', 'Goals'],
        type: 'idea',
      ),
      Note(
        id: 'note-4',
        title: 'Weekend Trek to Nandi Hills',
        content: 'Early 4:30 AM sunrise ride with college roommates. The fog rolling over the cliffs was breathtaking. Took quiet moments by the temple to just breathe and disconnect from screen time. Need more weekends in nature.',
        category: 'Travel',
        mood: '😌',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
        isFavorite: true,
        tags: ['Travel', 'Nature', 'Friends', 'Sunrise'],
        type: 'note',
      ),
      Note(
        id: 'note-5',
        title: 'Designing Without Clutter - Linear & Apple Notes',
        content: 'Key takeaways from studying premium productivity tools:\n1. Typography hierarchy over heavy borders\n2. Subtle elevation and contextual actions\n3. Micro-interactions when saving or toggling favorites\n4. Dark mode should feel like slate obsidian, not harsh zero-black contrast.',
        category: 'Ideas',
        mood: '😊',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
        isFavorite: true,
        tags: ['UI Design', 'Minimalism', 'Inspiration'],
        type: 'idea',
      ),
      Note(
        id: 'note-6',
        title: 'Things I Want To Learn Next Quarter',
        content: '1. Dart Isolates and background thread communication\n2. Canvas shaders and Skia/Impeller shader programming\n3. Offline-first CRDT synchronization algorithms\n4. Rust for embedded mobile libraries.',
        category: 'Personal',
        mood: '🤔',
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
        isFavorite: false,
        tags: ['Learning', 'Dart', 'Rust', 'Future'],
        type: 'note',
      ),
      Note(
        id: 'note-7',
        title: 'Reflections on "Atomic Habits"',
        content: 'Quote: "You do not rise to the level of your goals. You fall to the level of your systems."\nFocusing on small 1% daily iterations on my code quality rather than waiting for giant bursts of inspiration before college project deadlines.',
        category: 'Personal',
        mood: '😌',
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 6)),
        isFavorite: true,
        tags: ['Books', 'Habits', 'SelfGrowth'],
        type: 'reflection',
      ),
      Note(
        id: 'note-8',
        title: 'Firebase Authentication & Security Rules Memo',
        content: 'Rules must validate request.auth != null and enforce role-based access checks. Always separate user profile docs into users/\$(request.auth.uid) so Firestore rules remain clean and verifiable without extra reads.',
        category: 'Work',
        mood: '😊',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
        isFavorite: false,
        tags: ['Firebase', 'Security', 'Backend'],
        type: 'note',
      ),
      Note(
        id: 'note-9',
        title: 'Audio Memo: Ideas on Adaptive Screen Layouts',
        content: 'Voice transcription note: Use NavigationRail when screen width > 768px. Automatically transition from 1-column card stack to a 2-column or 3-column staggered masonry grid. Keep floating action button reachable.',
        category: 'Ideas',
        mood: '🔥',
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 8)),
        isFavorite: false,
        tags: ['Voice', 'Responsive', 'UX'],
        type: 'voice',
      ),
      Note(
        id: 'note-10',
        title: 'Campus Photography - Rainy Afternoon',
        content: 'Monsoon season on campus: reflection of library lights on the wet pavement. Capturing small aesthetic moments makes stressful exam weeks feel much calmer.',
        category: 'Personal',
        mood: '😌',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
        isFavorite: false,
        tags: ['Photo', 'Campus', 'Monsoon'],
        type: 'photo',
      ),
      Note(
        id: 'note-11',
        title: 'Sprint Backlog: Complete College Project Submission',
        content: 'Checklist:\n- [x] Responsive layout with Breakpoints\n- [x] Memory Map Interactive Graph\n- [x] Time Capsule countdown logic\n- [x] Mood tracker and weekly visualization\n- [x] Material 3 Dark and Light modes\n- [ ] Final live demonstration rehearsal',
        category: 'Study',
        mood: '🔥',
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now.subtract(const Duration(days: 12)),
        isFavorite: true,
        tags: ['College', 'Sprint', 'Flutter'],
        type: 'task',
      ),
      Note(
        id: 'note-12',
        title: 'Year Ago: My First Lines of Dart',
        content: 'I want to become really good at Flutter. Today I ran "flutter create" for the first time and saw the blue counter app. It felt magical seeing hot reload update the screen instantly.',
        category: 'Personal',
        mood: '😊',
        createdAt: DateTime(now.year - 1, now.month, now.day, 10, 30),
        updatedAt: DateTime(now.year - 1, now.month, now.day, 10, 30),
        isFavorite: true,
        tags: ['Milestone', 'Flutter', 'Nostalgia'],
        type: 'reflection',
      ),
    ];
  }

  static List<MoodEntry> getInitialMoods() {
    final now = DateTime.now();
    return [
      MoodEntry(
        id: 'mood-1',
        emoji: '🔥',
        label: 'Motivated',
        note: 'Making massive progress on my Flutter college project!',
        date: now,
      ),
      MoodEntry(
        id: 'mood-2',
        emoji: '😊',
        label: 'Happy',
        note: 'Met friends at the campus cafe and solved a tricky algorithm problem.',
        date: now.subtract(const Duration(days: 1)),
      ),
      MoodEntry(
        id: 'mood-3',
        emoji: '😌',
        label: 'Calm',
        note: 'Finished my DBMS assignments early and read two chapters of a novel.',
        date: now.subtract(const Duration(days: 2)),
      ),
      MoodEntry(
        id: 'mood-4',
        emoji: '🤔',
        label: 'Curious',
        note: 'Exploring how CustomPainter renders Bézier curves.',
        date: now.subtract(const Duration(days: 3)),
      ),
      MoodEntry(
        id: 'mood-5',
        emoji: '🔥',
        label: 'Motivated',
        note: 'Drafted my resume for summer software engineering internships.',
        date: now.subtract(const Duration(days: 4)),
      ),
      MoodEntry(
        id: 'mood-6',
        emoji: '😌',
        label: 'Calm',
        note: 'Quiet evening listening to ambient lo-fi and organizing notes.',
        date: now.subtract(const Duration(days: 5)),
      ),
      MoodEntry(
        id: 'mood-7',
        emoji: '😊',
        label: 'Happy',
        note: 'Weekend group project meetup went really well.',
        date: now.subtract(const Duration(days: 6)),
      ),
    ];
  }

  static List<TimeCapsule> getInitialCapsules() {
    final now = DateTime.now();
    return [
      TimeCapsule(
        id: 'capsule-1',
        title: 'Open After College Graduation',
        message: 'Dear future self,\n\nIf you are reading this, you made it through all the late-night debugging sessions, final year submissions, and endless coffee runs! Never forget the hunger and excitement you had when writing your first Flutter app. Stay curious, build things that solve real human problems, and always make time for the people who believed in you.',
        createdAt: now.subtract(const Duration(days: 120)),
        unlockDate: now.add(const Duration(days: 247)),
        isOpened: false,
      ),
      TimeCapsule(
        id: 'capsule-2',
        title: 'Letter to My 2027 Software Engineer Self',
        message: 'Remember when you were anxious about tech interviews and database normalization? Look at how far you have come. Keep learning new paradigms, mentor someone just starting out, and do not stop building side projects for the pure joy of it.',
        createdAt: now.subtract(const Duration(days: 45)),
        unlockDate: now.add(const Duration(days: 365)),
        isOpened: false,
      ),
      TimeCapsule(
        id: 'capsule-3',
        title: 'Unlocked: First Semester College Check-In',
        message: '🎉 Congratulations on opening your first MindVault capsule!\n\nYou wrote this at the start of the semester: "I promise to stay consistent, give my best to every lab project, and build an app that I can proudly show to faculty and recruiters."\n\nYou did exactly that. Keep raising your own bar!',
        createdAt: now.subtract(const Duration(days: 90)),
        unlockDate: now.subtract(const Duration(days: 1)),
        isOpened: true, // DEMO UNLOCKED CAPSULE
      ),
    ];
  }

  static List<MemoryNode> getInitialNodes() {
    return [
      MemoryNode(id: 'node-flutter', label: 'Flutter', category: 'Study', x: 0.50, y: 0.15, count: 5, iconName: 'flutter'),
      MemoryNode(id: 'node-ui', label: 'UI Design', category: 'Ideas', x: 0.28, y: 0.35, count: 4, iconName: 'palette'),
      MemoryNode(id: 'node-backend', label: 'Firebase', category: 'Work', x: 0.72, y: 0.35, count: 3, iconName: 'database'),
      MemoryNode(id: 'node-anim', label: 'Animations', category: 'Ideas', x: 0.20, y: 0.60, count: 3, iconName: 'motion'),
      MemoryNode(id: 'node-auth', label: 'Authentication', category: 'Work', x: 0.80, y: 0.60, count: 2, iconName: 'lock'),
      MemoryNode(id: 'node-projects', label: 'Projects', category: 'Study', x: 0.50, y: 0.52, count: 6, iconName: 'folder'),
      MemoryNode(id: 'node-habits', label: 'Habits', category: 'Personal', x: 0.35, y: 0.82, count: 3, iconName: 'sparkles'),
      MemoryNode(id: 'node-career', label: 'Internships', category: 'Goals', x: 0.65, y: 0.82, count: 3, iconName: 'briefcase'),
      MemoryNode(id: 'node-dbms', label: 'DBMS', category: 'Study', x: 0.88, y: 0.40, count: 2, iconName: 'server'),
      MemoryNode(id: 'node-travel', label: 'Travel', category: 'Travel', x: 0.12, y: 0.42, count: 2, iconName: 'map'),
    ];
  }

  static List<MemoryEdge> getInitialEdges() {
    return [
      MemoryEdge(fromId: 'node-flutter', toId: 'node-ui'),
      MemoryEdge(fromId: 'node-flutter', toId: 'node-backend'),
      MemoryEdge(fromId: 'node-flutter', toId: 'node-projects'),
      MemoryEdge(fromId: 'node-ui', toId: 'node-anim'),
      MemoryEdge(fromId: 'node-backend', toId: 'node-auth'),
      MemoryEdge(fromId: 'node-backend', toId: 'node-dbms'),
      MemoryEdge(fromId: 'node-projects', toId: 'node-career'),
      MemoryEdge(fromId: 'node-projects', toId: 'node-habits'),
      MemoryEdge(fromId: 'node-ui', toId: 'node-travel'),
    ];
  }
}
