import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MoodOption {
  final String emoji;
  final String label;

  const MoodOption(this.emoji, this.label);
}

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final ValueChanged<MoodOption> onMoodSelected;

  static const List<MoodOption> moods = [
    MoodOption('😊', 'Happy'),
    MoodOption('😌', 'Calm'),
    MoodOption('🔥', 'Motivated'),
    MoodOption('🤔', 'Curious'),
    MoodOption('😔', 'Sad'),
    MoodOption('😡', 'Frustrated'),
  ];

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: moods.map((m) {
          final isSelected = m.emoji == selectedMood;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onMoodSelected(m),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryViolet.withOpacity(0.12)
                        : (isDark ? const Color(0xFF1E1F2C) : const Color(0xFFF1F3F8)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryViolet
                          : (isDark ? const Color(0xFF2E3044) : const Color(0xFFE2E4EB)),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        m.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        m.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.primaryViolet
                              : (isDark ? Colors.white70 : const Color(0xFF4B5563)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
