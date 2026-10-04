import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import '../widgets/quick_capture_sheet.dart';
import '../widgets/stat_card.dart';
import 'mood_screen.dart';
import 'note_detail_screen.dart';
import 'note_editor_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _openEditor(BuildContext context, {String type = 'note', String? category}) {
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

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E202E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF2B2D40) : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
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
    final provider = context.watch<AppProvider>();
    final recent = provider.recentNotes;
    final mood = provider.todayMood;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getGreeting(),
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'What would you like to remember today?',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => QuickCaptureSheet.show(context),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('New memory'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primaryViolet,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SearchScreen()),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF191A26) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? const Color(0xFF292B3E) : const Color(0xFFE2E4EC),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Search your memories, tags, or ideas...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.white38 : Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'QUICK CAPTURE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildQuickAction(
                                context: context,
                                icon: Icons.edit_note_rounded,
                                label: 'Note',
                                color: const Color(0xFF3B82F6),
                                onTap: () => _openEditor(context),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickAction(
                                context: context,
                                icon: Icons.lightbulb_outline_rounded,
                                label: 'Idea',
                                color: const Color(0xFFF59E0B),
                                onTap: () => _openEditor(context, type: 'idea', category: 'Ideas'),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickAction(
                                context: context,
                                icon: Icons.check_circle_outline_rounded,
                                label: 'Task',
                                color: const Color(0xFF10B981),
                                onTap: () => _openEditor(context, type: 'task', category: 'Study'),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickAction(
                                context: context,
                                icon: Icons.mood_rounded,
                                label: 'Mood',
                                color: const Color(0xFFEC4899),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const MoodScreen()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR SPACE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isDesktop ? 5 : (isTablet ? 3 : 2),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isDesktop ? 1.6 : 1.45,
                          children: [
                            StatCard(
                              title: 'Memories',
                              value: '${provider.totalMemoriesCount}',
                              icon: Icons.inventory_2_outlined,
                              accentColor: const Color(0xFF5B4DFF),
                            ),
                            StatCard(
                              title: 'Ideas',
                              value: '${provider.ideasCount}',
                              icon: Icons.lightbulb_outline_rounded,
                              accentColor: const Color(0xFFF59E0B),
                            ),
                            StatCard(
                              title: 'Reflections',
                              value: '${provider.reflectionsCount}',
                              icon: Icons.auto_awesome_outlined,
                              accentColor: const Color(0xFF10B981),
                            ),
                            StatCard(
                              title: 'Favorites',
                              value: '${provider.favoritesCount}',
                              icon: Icons.star_outline_rounded,
                              accentColor: const Color(0xFFEC4899),
                            ),
                            StatCard(
                              title: 'Time Capsules',
                              value: '${provider.capsulesCount}',
                              icon: Icons.lock_clock_outlined,
                              accentColor: const Color(0xFF8B5CF6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (mood != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF191A28) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? const Color(0xFF282A3E) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(mood.emoji, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Today's mood",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    mood.note.isEmpty ? mood.label : mood.note,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const MoodScreen()),
                              ),
                              icon: const Icon(Icons.chevron_right_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RECENT MEMORIES',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                          ),
                        ),
                        if (recent.isNotEmpty)
                          Text(
                            '${recent.length} recent',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                recent.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                          child: EmptyStateWidget.vaultEmpty(
                            onCapture: () => QuickCaptureSheet.show(context),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: isDesktop ? 1.45 : (isTablet ? 1.4 : 1.7),
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => NoteCard(note: recent[index]),
                            childCount: recent.length,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
