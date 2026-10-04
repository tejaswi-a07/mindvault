import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../screens/note_detail_screen.dart';
import '../screens/note_editor_screen.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onDeleted;

  const NoteCard({
    super.key,
    required this.note,
    this.onDeleted,
  });

  IconData _getTypeIcon(String? type, String category) {
    switch (type) {
      case 'idea':
        return Icons.lightbulb_outline_rounded;
      case 'task':
        return Icons.check_circle_outline_rounded;
      case 'reflection':
        return Icons.auto_awesome_outlined;
      case 'voice':
        return Icons.mic_none_rounded;
      case 'photo':
        return Icons.image_outlined;
      default:
        switch (category) {
          case 'Study':
            return Icons.school_outlined;
          case 'Work':
            return Icons.work_outline_rounded;
          case 'Travel':
            return Icons.explore_outlined;
          case 'Goals':
            return Icons.flag_outlined;
          default:
            return Icons.description_outlined;
        }
    }
  }

  void _showOptionsSheet(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardTheme.color ?? theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit Memory'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteEditorScreen(noteToEdit: note),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    note.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    color: note.isFavorite ? Colors.amber : null,
                  ),
                  title: Text(note.isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
                  onTap: () {
                    Navigator.pop(ctx);
                    provider.toggleFavorite(note.id);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  title: const Text('Delete Memory', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmDelete(context, provider);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Memory?'),
        content: const Text(
          'This memory will be permanently removed from your vault. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              provider.deleteNote(note.id);
              if (onDeleted != null) onDeleted!();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Memory deleted from Vault'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catColor = AppTheme.getCategoryColor(note.category);
    final dateStr = DateFormat('MMM d, yyyy').format(note.createdAt);
    final cardBg = theme.cardTheme.color ?? theme.colorScheme.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteDetailScreen(noteId: note.id),
            ),
          );
        },
        onLongPress: () => _showOptionsSheet(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF28293D) : const Color(0xFFE8EAF2),
              width: 1,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: Icon, Category Badge, Mood, and Favorite Star
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(note.type, note.category),
                      size: 15,
                      color: catColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      note.category,
                      style: TextStyle(
                        color: catColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    note.mood,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 6),
                  Consumer<AppProvider>(
                    builder: (context, provider, child) {
                      return GestureDetector(
                        onTap: () => provider.toggleFavorite(note.id),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            note.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                            key: ValueKey(note.isFavorite),
                            size: 19,
                            color: note.isFavorite ? const Color(0xFFFBBF24) : (isDark ? Colors.white30 : Colors.black26),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Title
              Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: -0.3,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              // Content Preview (Flexible so it adapts cleanly inside both constrained grids and natural lists)
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    height: 1.35,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Footer: Date and Tag previews
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  const Spacer(),
                  if (note.tags.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF222332) : const Color(0xFFF1F3F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${note.tags.first}',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
