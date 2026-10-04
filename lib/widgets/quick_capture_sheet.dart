import 'package:flutter/material.dart';
import '../screens/mood_screen.dart';
import '../screens/note_editor_screen.dart';
import '../theme/app_theme.dart';

class QuickCaptureSheet extends StatelessWidget {
  const QuickCaptureSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => const QuickCaptureSheet(),
    );
  }

  void _openEditor(BuildContext context, {String type = 'note', String? category}) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          defaultCategory: category,
          initialType: type,
        ),
      ),
    );
  }

  Widget _buildCaptureItem({
    required BuildContext context,
    required IconData icon,
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
                child: Icon(icon, color: color, size: 22),
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
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'New memory',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose what you want to capture.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white60 : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 18),
            _buildCaptureItem(
              context: context,
              icon: Icons.edit_note_rounded,
              title: 'Note',
              subtitle: 'Write a thought, lecture memo, or reflection.',
              color: const Color(0xFF3B82F6),
              onTap: () => _openEditor(context),
            ),
            const SizedBox(height: 10),
            _buildCaptureItem(
              context: context,
              icon: Icons.lightbulb_outline_rounded,
              title: 'Idea',
              subtitle: 'Save a creative idea or future project concept.',
              color: const Color(0xFFF59E0B),
              onTap: () => _openEditor(context, type: 'idea', category: 'Ideas'),
            ),
            const SizedBox(height: 10),
            _buildCaptureItem(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              title: 'Task',
              subtitle: 'Capture an action item or milestone.',
              color: const Color(0xFF10B981),
              onTap: () => _openEditor(context, type: 'task', category: 'Study'),
            ),
            const SizedBox(height: 10),
            _buildCaptureItem(
              context: context,
              icon: Icons.mood_rounded,
              title: 'Mood',
              subtitle: 'Record how you feel and what is on your mind.',
              color: const Color(0xFFEC4899),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoodScreen()),
                );
              },
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
