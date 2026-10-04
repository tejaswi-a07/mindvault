import 'package:flutter/material.dart';
import '../screens/camera_capture_screen.dart';
import '../screens/mood_screen.dart';
import '../screens/note_editor_screen.dart';
import '../screens/voice_capture_screen.dart';
import '../theme/app_theme.dart';

class QuickCaptureSheet extends StatelessWidget {
  const QuickCaptureSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      useSafeArea: true,
      showDragHandle: false,
      builder: (_) => const QuickCaptureSheet(),
    );
  }

  void _openEditor(BuildContext context, {String type = 'note', String? category}) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(defaultCategory: category, initialType: type),
      ),
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E202E) : const Color(0xFFF8F9FD),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? const Color(0xFF2C2E42) : const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: isDark ? Colors.white60 : const Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, size: 13, color: isDark ? Colors.white30 : Colors.black26),
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

    return FractionallySizedBox(
      heightFactor: 0.86,
      child: Material(
        color: isDark ? const Color(0xFF14151F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New memory', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                          const SizedBox(height: 4),
                          Text(
                            'Choose one capture method. Nothing is simulated.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: isDark ? Colors.white60 : const Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return _buildCaptureItem(
                          context: context,
                          icon: Icons.edit_note_rounded,
                          title: 'Note',
                          subtitle: 'Write a thought, memo, or reflection.',
                          color: const Color(0xFF3B82F6),
                          onTap: () => _openEditor(context),
                        );
                      case 1:
                        return _buildCaptureItem(
                          context: context,
                          icon: Icons.lightbulb_outline_rounded,
                          title: 'Idea',
                          subtitle: 'Save a creative idea or future concept.',
                          color: const Color(0xFFF59E0B),
                          onTap: () => _openEditor(context, type: 'idea', category: 'Ideas'),
                        );
                      case 2:
                        return _buildCaptureItem(
                          context: context,
                          icon: Icons.check_circle_outline_rounded,
                          title: 'Task',
                          subtitle: 'Capture an action item or milestone.',
                          color: const Color(0xFF10B981),
                          onTap: () => _openEditor(context, type: 'task', category: 'Study'),
                        );
                      case 3:
                        return _buildCaptureItem(
                          context: context,
                          icon: Icons.mood_rounded,
                          title: 'Mood',
                          subtitle: 'Record how you feel right now.',
                          color: const Color(0xFFEC4899),
                          onTap: () => _openScreen(context, const MoodScreen()),
                        );
                      case 4:
                        return _buildCaptureItem(
                          context: context,
                          icon: Icons.mic_none_rounded,
                          title: 'Voice',
                          subtitle: 'Record up to 20 seconds from your microphone.',
                          color: const Color(0xFF8B5CF6),
                          onTap: () => _openScreen(context, const VoiceCaptureScreen()),
                        );
                      default:
                        return _buildCaptureItem(
                          context: context,
                          icon: Icons.photo_camera_outlined,
                          title: 'Photo',
                          subtitle: 'Take a real photo with your camera.',
                          color: const Color(0xFF06B6D4),
                          onTap: () => _openScreen(context, const CameraCaptureScreen()),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
