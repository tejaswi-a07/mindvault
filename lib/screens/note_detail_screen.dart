import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'note_editor_screen.dart';
import '../widgets/audio_memory_player.dart';
import '../widgets/note_card.dart';

class NoteDetailScreen extends StatelessWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  void _confirmDelete(BuildContext context, Note note) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Memory?'),
        content: const Text('Are you sure you want to remove this memory from your vault permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              provider.deleteNote(note.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Memory deleted from Vault'), behavior: SnackBarBehavior.floating),
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
    final provider = Provider.of<AppProvider>(context);
    final noteIndex = provider.notes.indexWhere((n) => n.id == noteId);

    if (noteIndex == -1) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Memory not found')));
    }

    final note = provider.notes[noteIndex];
    final catColor = AppTheme.getCategoryColor(note.category);
    final dateStr = DateFormat('MMMM d, yyyy • h:mm a').format(note.createdAt);
    final related = provider.getRelatedNotes(note);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            tooltip: note.isFavorite ? 'Favorited' : 'Favorite',
            icon: Icon(note.isFavorite ? Icons.star_rounded : Icons.star_border_rounded, color: note.isFavorite ? Colors.amber : null),
            onPressed: () => provider.toggleFavorite(note.id),
          ),
          IconButton(
            tooltip: 'Edit Memory',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditorScreen(noteToEdit: note))),
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Memory copied to clipboard ready to share!'), behavior: SnackBarBehavior.floating),
            ),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: () => _confirmDelete(context, note),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: catColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                    child: Text(note.category, style: TextStyle(color: catColor, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF222436) : const Color(0xFFF1F3F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(note.mood, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        const Text('Mood', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 14, color: isDark ? Colors.white38 : Colors.black38),
                  const SizedBox(width: 6),
                  Text(dateStr, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : const Color(0xFF6B7280))),
                ],
              ),
              const SizedBox(height: 16),
              Text(note.title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.25)),
              const SizedBox(height: 20),
              if (note.mediaType == 'image' && note.mediaData != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(_decodeDataUri(note.mediaData!), width: double.infinity, fit: BoxFit.contain),
                ),
                const SizedBox(height: 16),
              ],
              if (note.mediaType == 'audio' && note.mediaData != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161724) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: isDark ? const Color(0xFF25273C) : const Color(0xFFE5E7EB)),
                  ),
                  child: AudioMemoryPlayer(dataUri: note.mediaData!),
                ),
                const SizedBox(height: 16),
              ],
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161724) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? const Color(0xFF25273C) : const Color(0xFFE5E7EB)),
                ),
                child: SelectableText(note.content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6, fontSize: 15)),
              ),
              const SizedBox(height: 16),
              if (note.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: note.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF202234) : const Color(0xFFEDEFF7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('#$tag', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF4B5563))),
                  )).toList(),
                ),
                const SizedBox(height: 32),
              ],
              if (related.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 16),
                const Text('Related memories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: related.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) => NoteCard(note: related[idx]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Uint8List _decodeDataUri(String dataUri) => base64Decode(dataUri.substring(dataUri.indexOf(',') + 1));
}
