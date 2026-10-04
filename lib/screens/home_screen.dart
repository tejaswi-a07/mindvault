import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/note_card.dart';
import '../widgets/quick_capture_sheet.dart';
import 'search_screen.dart';
import 'mood_screen.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 👋';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 👋';
  }

  Widget _buildQuickCapturePill({
    required BuildContext context,
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top App Bar / Greeting Area
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "What's on your mind?",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                                );
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E202E) : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF2C2E42) : const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: const Icon(Icons.search_rounded, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Search Bar Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SearchScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF191A26) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? const Color(0xFF292B3E) : const Color(0xFFE2E4EC),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
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
                                  'Search your memory, ideas, tags...',
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
                        // Quick Capture Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'QUICK CAPTURE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => QuickCaptureSheet.show(context),
                              child: Text(
                                'View all',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryViolet,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildQuickCapturePill(
                                context: context,
                                emoji: '📝',
                                label: 'Note',
                                onTap: () => QuickCaptureSheet.show(context),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickCapturePill(
                                context: context,
                                emoji: '💡',
                                label: 'Idea',
                                onTap: () => QuickCaptureSheet.show(context),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickCapturePill(
                                context: context,
                                emoji: '☑',
                                label: 'Task',
                                onTap: () => QuickCaptureSheet.show(context),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickCapturePill(
                                context: context,
                                emoji: '😊',
                                label: 'Mood',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const MoodScreen()),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickCapturePill(
                                context: context,
                                emoji: '🎙',
                                label: 'Voice',
                                onTap: () => QuickCaptureSheet.show(context),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickCapturePill(
                                context: context,
                                emoji: '📷',
                                label: 'Photo',
                                onTap: () => QuickCaptureSheet.show(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // YOUR SPACE STATS
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
                        // Responsive Stat Cards Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isDesktop ? 5 : (isTablet ? 3 : 2),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isDesktop ? 1.6 : (isTablet ? 1.5 : 1.45),
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

                // TODAY'S REFLECTION & ON THIS DAY CARDS
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildTodayReflection(context, provider, isDark)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildOnThisDay(context, provider, isDark)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildTodayReflection(context, provider, isDark),
                              const SizedBox(height: 14),
                              _buildOnThisDay(context, provider, isDark),
                            ],
                          ),
                  ),
                ),

                // RECENT MEMORIES HEADER
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
                        Text(
                          'Showing ${provider.recentNotes.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // RECENT MEMORIES GRID / LIST
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: isDesktop ? 1.45 : (isTablet ? 1.4 : 1.7),
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final note = provider.recentNotes[index];
                        return NoteCard(note: note);
                      },
                      childCount: provider.recentNotes.length,
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

  Widget _buildTodayReflection(BuildContext context, AppProvider provider, bool isDark) {
    final mood = provider.todayMood;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191A28) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF282A3E) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF10B981), size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                "Today's Reflection",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              if (mood != null)
                Text(
                  '${mood.emoji} Feeling ${mood.label.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mood != null && mood.note.isNotEmpty
                ? '"${mood.note}"'
                : '"Today I finally started building my Flutter project. Setting high standards for design and user experience."',
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoodScreen()),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add reflection', style: TextStyle(fontSize: 13)),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryViolet,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnThisDay(BuildContext context, AppProvider provider, bool isDark) {
    final note = provider.onThisDayNote;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191A28) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF282A3E) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.history_rounded, color: Color(0xFFF59E0B), size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'On This Day',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF252638) : const Color(0xFFEDEFF7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '1 year ago',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            note != null
                ? 'You wrote:\n"${note.title}: ${note.content.split('\n').first}"'
                : 'You wrote:\n"I want to become really good at Flutter and build impactful products."',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                if (note != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NoteDetailScreen(noteId: note.id)),
                  );
                }
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('View memory', style: TextStyle(fontSize: 13)),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF59E0B),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
