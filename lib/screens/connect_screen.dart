import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/connection.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/memory_map.dart';
import '../widgets/note_card.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = Provider.of<AppProvider>(context);
    final selectedNode = provider.selectedNode;
    final List<Note> relatedNotes = selectedNode != null
        ? provider.getRelatedNotesForNode(selectedNode)
        : <Note>[];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Screen Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Mind',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'See how your thoughts connect.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      if (selectedNode != null)
                        TextButton.icon(
                          onPressed: () => provider.selectNode(null),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          label: const Text('Reset view', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            foregroundColor: isDark ? Colors.white60 : const Color(0xFF6B7280),
                          ),
                        ),
                    ],
                  ),
                ),

                // Interactive Canvas & Connected Details
                Expanded(
                  child: isDesktop
                      ? Row(
                          children: [
                            // Canvas on the Left
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 10, 20),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF13141F) : Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF222434) : const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: MemoryMapWidget(
                                    nodes: provider.nodes,
                                    edges: provider.edges,
                                    selectedNode: selectedNode,
                                    onNodeSelected: (node) => provider.selectNode(node),
                                  ),
                                ),
                              ),
                            ),
                            // Connected Panel on the Right
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 20, 20),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF161724) : Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF222434) : const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: _buildConnectedInspector(context, provider, selectedNode, relatedNotes, isDark),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            // Interactive Canvas Area
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF13141F) : Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF222434) : const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: MemoryMapWidget(
                                    nodes: provider.nodes,
                                    edges: provider.edges,
                                    selectedNode: selectedNode,
                                    onNodeSelected: (node) => provider.selectNode(node),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Bottom Drawer / Details
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF171825) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF25273A) : const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: _buildConnectedInspector(context, provider, selectedNode, relatedNotes, isDark),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildConnectedInspector(
    BuildContext context,
    AppProvider provider,
    MemoryNode? selectedNode,
    List<Note> relatedNotes,
    bool isDark,
  ) {
    if (selectedNode == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryViolet.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.touch_app_outlined,
                  size: 28,
                  color: AppTheme.primaryViolet,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Explore the Mind Graph',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap any node to trace linked topics and surfacing memories.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final catColor = AppTheme.getCategoryColor(selectedNode.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inspector Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: catColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                selectedNode.label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedNode.category,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: catColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${relatedNotes.length} linked',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Related Memories List
        Expanded(
          child: relatedNotes.isEmpty
              ? Center(
                  child: Text(
                    'No direct notes logged under "${selectedNode.label}" yet.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(14),
                  physics: const BouncingScrollPhysics(),
                  itemCount: relatedNotes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final note = relatedNotes[idx];
                    return NoteCard(note: note);
                  },
                ),
        ),
      ],
    );
  }
}
