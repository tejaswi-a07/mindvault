import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<String> popularTopics = [
    'Flutter',
    'Firebase',
    'UI Design',
    'Architecture',
    'DBMS',
    'Internship',
    'Habits',
    'Travel',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTagTapped(String tag) {
    _searchController.text = tag;
    setState(() => _query = tag);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = Provider.of<AppProvider>(context);
    final results = provider.searchNotes(_query);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (val) => setState(() => _query = val),
          decoration: InputDecoration(
            hintText: 'Search your memory...',
            border: InputBorder.none,
            fillColor: Colors.transparent,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Suggested Topics Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RELATED TOPICS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: popularTopics.map((topic) {
                            final isSel = _query.toLowerCase() == topic.toLowerCase();
                            return ActionChip(
                              label: Text('#$topic'),
                              backgroundColor: isSel
                                  ? AppTheme.primaryViolet
                                  : (isDark ? const Color(0xFF1E202E) : const Color(0xFFEDEFF6)),
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSel
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : const Color(0xFF4B5563)),
                              ),
                              onPressed: () => _onTagTapped(topic),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Results Header
                if (_query.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Text(
                        'Found ${results.length} memories for "$_query"',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryViolet,
                        ),
                      ),
                    ),
                  ),

                // Results or Empty State
                if (_query.isNotEmpty && results.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget.searchEmpty(
                      onClear: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
                  )
                else if (_query.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: isDesktop ? 1.45 : (isTablet ? 1.4 : 1.7),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return NoteCard(note: results[index]);
                        },
                        childCount: results.length,
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                      child: Center(
                        child: Text(
                          'Type keywords, tags, or select a topic above to search your vault.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
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
