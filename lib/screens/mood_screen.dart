import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/mood_selector.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String _selectedEmoji = '🔥';
  String _selectedLabel = 'Motivated';
  final TextEditingController _reflectionController = TextEditingController();

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _saveMood(AppProvider provider) {
    provider.addMood(_selectedEmoji, _selectedLabel, _reflectionController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(_selectedEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text('Recorded $_selectedLabel mood into your vault!'),
          ],
        ),
        backgroundColor: AppTheme.primaryViolet,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood & Reflection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Prompt Question
              Text(
                'How are you feeling today?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tracking emotional shifts helps unlock patterns in productivity and focus.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 20),

              // Mood Options Selector
              MoodSelector(
                selectedMood: _selectedEmoji,
                onMoodSelected: (opt) {
                  setState(() {
                    _selectedEmoji = opt.emoji;
                    _selectedLabel = opt.label;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Behind That Feeling Reflection
              Text(
                "What's behind that feeling?",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reflectionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Add an optional note about what shaped your mindset today...',
                  fillColor: isDark ? const Color(0xFF1B1C2A) : const Color(0xFFF3F4F9),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _saveMood(provider),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Save Reflection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryViolet,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Weekly Mood History Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WEEKLY MOOD HISTORY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    'Past 7 entries',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Weekly Visual Timeline Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161724) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF24263A) : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Column(
                  children: [
                    // Day of Week Horizontal Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: provider.moods.take(7).map((entry) {
                          final dayStr = DateFormat('E').format(entry.date);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Text(
                                  entry.emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  dayStr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat('d').format(entry.date),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? Colors.white38 : Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(height: 24),
                    // Recent Mood Notes List
                    ...provider.moods.take(3).map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.emoji, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.label,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('MMM d').format(entry.date),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? Colors.white38 : Colors.black38,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (entry.note.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      entry.note,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
