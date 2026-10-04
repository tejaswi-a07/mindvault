import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/quick_capture_sheet.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  static const List<String> categories = [
    'All',
    'Personal',
    'Study',
    'Ideas',
    'Work',
    'Travel',
    'Goals',
  ];

  void _showSortDialog(BuildContext context, AppProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Sort Vault',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.schedule_rounded),
                  title: const Text('Newest First'),
                  trailing: provider.sortOption == NoteSortOption.newest
                      ? const Icon(Icons.check, color: AppTheme.primaryViolet)
                      : null,
                  onTap: () {
                    provider.setSortOption(NoteSortOption.newest);
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: const Text('Oldest First'),
                  trailing: provider.sortOption == NoteSortOption.oldest
                      ? const Icon(Icons.check, color: AppTheme.primaryViolet)
                      : null,
                  onTap: () {
                    provider.setSortOption(NoteSortOption.oldest);
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha_rounded),
                  title: const Text('A – Z Alphabetical'),
                  trailing: provider.sortOption == NoteSortOption.alphabetical
                      ? const Icon(Icons.check, color: AppTheme.primaryViolet)
                      : null,
                  onTap: () {
                    provider.setSortOption(NoteSortOption.alphabetical);
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_rounded, color: Colors.pinkAccent),
                  title: const Text('Most Loved (Favorites)'),
                  trailing: provider.sortOption == NoteSortOption.mostLoved
                      ? const Icon(Icons.check, color: AppTheme.primaryViolet)
                      : null,
                  onTap: () {
                    provider.setSortOption(NoteSortOption.mostLoved);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = Provider.of<AppProvider>(context);
    final notes = provider.filteredVaultNotes;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Vault Header Area
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
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
                                  'Your Vault',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Everything worth remembering.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                            // Sort and Filter Action Buttons
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'Sort memories',
                                  onPressed: () => _showSortDialog(context, provider),
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1E202E) : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDark ? const Color(0xFF2C2E42) : const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: const Icon(Icons.swap_vert_rounded, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Vault Search TextField
                        TextField(
                          onChanged: (val) => provider.setSearchQuery(val),
                          decoration: InputDecoration(
                            hintText: 'Filter your vault by title, tag or text...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            suffixIcon: provider.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () => provider.setSearchQuery(''),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Category Horizontal Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: categories.map((cat) {
                              final count = cat == 'All'
                                  ? provider.notes.length
                                  : provider.notes.where((n) => n.category.toLowerCase() == cat.toLowerCase()).length;
                              return CategoryChip(
                                label: cat,
                                count: count,
                                isSelected: provider.selectedCategory == cat,
                                onTap: () => provider.setSelectedCategory(cat),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Note Count & Current Sort Status
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${notes.length} ${notes.length == 1 ? 'memory' : 'memories'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                            color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showSortDialog(context, provider),
                          child: Row(
                            children: [
                              Text(
                                'Sorted by: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                              ),
                              Text(
                                provider.sortOption.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryViolet,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid of Notes or Empty State
                notes.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyStateWidget.vaultEmpty(
                          onCapture: () => QuickCaptureSheet.show(context),
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
                            (context, index) {
                              final note = notes[index];
                              return NoteCard(note: note);
                            },
                            childCount: notes.length,
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
