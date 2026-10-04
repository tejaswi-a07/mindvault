import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/note_editor_screen.dart';
import '../screens/mood_screen.dart';

class QuickCaptureSheet extends StatelessWidget {
  const QuickCaptureSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickCaptureSheet(),
    );
  }

  Widget _buildCaptureItem({
    required BuildContext context,
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E202E) : const Color(0xFFF8F9FD),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF2C2E42) : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSimulatedMediaDialog(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String noteType,
  }) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(icon, color: AppTheme.primaryViolet),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoteEditorScreen(
                    defaultCategory: noteType == 'voice' ? 'Ideas' : 'Personal',
                    initialType: noteType,
                  ),
                ),
              );
            },
            child: const Text('Add Memory Note'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14151F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Sheet Header
          Text(
            'Capture a thought',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Don't organize it yet. Just save it.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white60 : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 20),
          // Options List
          _buildCaptureItem(
            context: context,
            emoji: '📝',
            title: 'Note',
            subtitle: 'Freeform thoughts, lecture memos, reflections',
            color: const Color(0xFF3B82F6),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NoteEditorScreen(initialType: 'note'),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildCaptureItem(
            context: context,
            emoji: '💡',
            title: 'Idea',
            subtitle: 'Spark of creativity or future startup concept',
            color: const Color(0xFFF59E0B),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NoteEditorScreen(
                    defaultCategory: 'Ideas',
                    initialType: 'idea',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildCaptureItem(
            context: context,
            emoji: '☑',
            title: 'Task',
            subtitle: 'Action item or milestone checklist',
            color: const Color(0xFF10B981),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NoteEditorScreen(
                    defaultCategory: 'Study',
                    initialType: 'task',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildCaptureItem(
            context: context,
            emoji: '😊',
            title: 'Mood',
            subtitle: 'Log your emotional state and what triggered it',
            color: const Color(0xFFEC4899),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MoodScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildCaptureItem(
            context: context,
            emoji: '🎙',
            title: 'Voice',
            subtitle: 'Simulated audio memo note recorder',
            color: const Color(0xFF8B5CF6),
            onTap: () {
              Navigator.pop(context);
              _showSimulatedMediaDialog(
                context,
                title: 'Voice Memo Simulation',
                description:
                    'Simulated audio memo captured. Would you like to transcribe and attach this to a new memory?',
                icon: Icons.mic_none_rounded,
                noteType: 'voice',
              );
            },
          ),
          const SizedBox(height: 10),
          _buildCaptureItem(
            context: context,
            emoji: '📷',
            title: 'Photo',
            subtitle: 'Simulated visual snapshot memo',
            color: const Color(0xFF06B6D4),
            onTap: () {
              Navigator.pop(context);
              _showSimulatedMediaDialog(
                context,
                title: 'Photo Memory Simulation',
                description:
                    'Simulated snapshot saved. Would you like to create a memory card with this photo entry?',
                icon: Icons.camera_alt_outlined,
                noteType: 'photo',
              );
            },
          ),
        ],
      ),
    );
  }
}
