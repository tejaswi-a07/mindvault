import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/mood_selector.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? noteToEdit;
  final String? defaultCategory;
  final String? initialType;

  const NoteEditorScreen({
    super.key,
    this.noteToEdit,
    this.defaultCategory,
    this.initialType,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagInputController;

  late String _category;
  late String _mood;
  late bool _isFavorite;
  late List<String> _tags;
  late String _noteType;

  static const List<String> categories = [
    'Personal',
    'Study',
    'Ideas',
    'Work',
    'Travel',
    'Goals',
  ];

  @override
  void initState() {
    super.initState();
    final n = widget.noteToEdit;
    _titleController = TextEditingController(text: n?.title ?? '');
    _contentController = TextEditingController(text: n?.content ?? '');
    _tagInputController = TextEditingController();

    _category = n?.category ?? widget.defaultCategory ?? 'Personal';
    _mood = n?.mood ?? '😊';
    _isFavorite = n?.isFavorite ?? false;
    _tags = n != null ? List<String>.from(n.tags) : [];
    _noteType = n?.type ?? widget.initialType ?? 'note';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  void _addTag(String value) {
    final clean = value.trim().replaceAll('#', '');
    if (clean.isNotEmpty && !_tags.contains(clean)) {
      setState(() {
        _tags.add(clean);
        _tagInputController.clear();
      });
    }
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<AppProvider>(context, listen: false);
    final now = DateTime.now();

    if (widget.noteToEdit == null) {
      // Create new note
      final newNote = Note(
        id: 'note-${now.millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _category,
        mood: _mood,
        createdAt: now,
        updatedAt: now,
        isFavorite: _isFavorite,
        tags: _tags,
        type: _noteType,
      );
      provider.addNote(newNote);
    } else {
      // Update existing note
      final updated = widget.noteToEdit!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _category,
        mood: _mood,
        updatedAt: now,
        isFavorite: _isFavorite,
        tags: _tags,
        type: _noteType,
      );
      provider.updateNote(updated);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(widget.noteToEdit == null ? 'Memory saved to Vault!' : 'Memory updated!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.noteToEdit != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEditing ? 'Edit Memory' : 'New Memory'),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Remove Favorite' : 'Mark as Favorite',
            icon: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _isFavorite ? Colors.amber : null,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryViolet,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
                decoration: const InputDecoration(
                  hintText: 'Memory Title...',
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please give your memory a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Selector
              const Text(
                'Category',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: categories.map((cat) {
                    final isSel = _category == cat;
                    final catColor = AppTheme.getCategoryColor(cat);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        selectedColor: catColor.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSel ? catColor : (isDark ? Colors.white70 : const Color(0xFF4B5563)),
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _category = cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Mood Selector
              const Text(
                'Associated Mood',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              MoodSelector(
                selectedMood: _mood,
                onMoodSelected: (opt) => setState(() => _mood = opt.emoji),
              ),
              const SizedBox(height: 20),

              // Content Field
              TextFormField(
                controller: _contentController,
                maxLines: null,
                minLines: 8,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'What thoughts, insights, or details would you like to preserve?',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter some memory content';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_contentController.text.length} characters',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tags Section
              const Text(
                'Tags (#topics)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagInputController,
                      decoration: const InputDecoration(
                        hintText: 'Add a tag and press Add...',
                        prefixText: '#',
                      ),
                      onSubmitted: _addTag,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _addTag(_tagInputController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF282A3E) : const Color(0xFFE5E7EB),
                      foregroundColor: isDark ? Colors.white : Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text('#$tag'),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => setState(() => _tags.remove(tag)),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
