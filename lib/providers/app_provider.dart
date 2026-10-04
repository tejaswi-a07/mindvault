import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_data.dart';
import '../models/capsule.dart';
import '../models/connection.dart';
import '../models/mood.dart';
import '../models/note.dart';

enum NoteSortOption { newest, oldest, alphabetical, mostLoved }

class AppProvider with ChangeNotifier {
  static const _notesKey = 'mindvault.notes';
  static const _moodsKey = 'mindvault.moods';
  static const _capsulesKey = 'mindvault.capsules';
  static const _themeKey = 'mindvault.theme';
  static const _accentKey = 'mindvault.accent';

  List<Note> _notes = [];
  List<MoodEntry> _moods = [];
  List<TimeCapsule> _capsules = [];
  List<MemoryNode> _nodes = [];
  List<MemoryEdge> _edges = [];

  String _selectedCategory = 'All';
  NoteSortOption _sortOption = NoteSortOption.newest;
  String _searchQuery = '';
  MemoryNode? _selectedNode;
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = const Color(0xFF5B4DFF);

  AppProvider() {
    _initializeData();
    _loadPersistedData();
  }

  void _initializeData() {
    _notes = [];
    _moods = [];
    _capsules = [];
    _nodes = [];
    _edges = [];
  }

  Future<void> _loadPersistedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notes = prefs.getString(_notesKey);
      final moods = prefs.getString(_moodsKey);
      final capsules = prefs.getString(_capsulesKey);

      if (notes != null) {
        _notes = (jsonDecode(notes) as List)
            .map((item) => Note.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
      if (moods != null) {
        _moods = (jsonDecode(moods) as List)
            .map((item) => MoodEntry.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
      if (capsules != null) {
        _capsules = (jsonDecode(capsules) as List)
            .map((item) => TimeCapsule.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }

      final savedTheme = prefs.getString(_themeKey);
      if (savedTheme != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == savedTheme,
          orElse: () => ThemeMode.system,
        );
      }

      final savedAccent = prefs.getInt(_accentKey);
      if (savedAccent != null) _accentColor = Color(savedAccent);
    } catch (_) {
      _initializeData();
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, jsonEncode(_notes.map((n) => n.toJson()).toList()));
    await prefs.setString(_moodsKey, jsonEncode(_moods.map((m) => m.toJson()).toList()));
    await prefs.setString(_capsulesKey, jsonEncode(_capsules.map((c) => c.toJson()).toList()));
    await prefs.setString(_themeKey, _themeMode.name);
    await prefs.setInt(_accentKey, _accentColor.value);
  }

  List<Note> get notes => List.unmodifiable(_notes);
  List<MoodEntry> get moods => List.unmodifiable(_moods);
  List<TimeCapsule> get capsules => List.unmodifiable(_capsules);
  List<MemoryNode> get nodes => List.unmodifiable(_nodes);
  List<MemoryEdge> get edges => List.unmodifiable(_edges);
  String get selectedCategory => _selectedCategory;
  NoteSortOption get sortOption => _sortOption;
  String get searchQuery => _searchQuery;
  MemoryNode? get selectedNode => _selectedNode;
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  // Dashboard metrics reflect the user's actual stored data rather than
  // decorative placeholder offsets.
  int get totalMemoriesCount => _notes.length;
  int get ideasCount => _notes.where((n) => n.category == 'Ideas' || n.type == 'idea').length;
  int get reflectionsCount => _moods.length;
  int get favoritesCount => _notes.where((n) => n.isFavorite).length;
  int get capsulesCount => _capsules.length;
  MoodEntry? get todayMood => _moods.isEmpty ? null : _moods.first;

  Note? get onThisDayNote {
    final past = _notes.where((n) => n.tags.contains('Nostalgia') || n.tags.contains('Milestone'));
    return past.isNotEmpty ? past.first : (_notes.isNotEmpty ? _notes.last : null);
  }

  List<Note> get recentNotes {
    final sorted = List<Note>.from(_notes)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(5).toList();
  }

  List<Note> get filteredVaultNotes {
    var result = List<Note>.from(_notes);
    if (_selectedCategory != 'All') {
      result = result.where((n) => n.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((n) =>
        n.title.toLowerCase().contains(query) ||
        n.content.toLowerCase().contains(query) ||
        n.category.toLowerCase().contains(query) ||
        n.tags.any((t) => t.toLowerCase().contains(query))).toList();
    }
    switch (_sortOption) {
      case NoteSortOption.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case NoteSortOption.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case NoteSortOption.alphabetical:
        result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case NoteSortOption.mostLoved:
        result.sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
    }
    return result;
  }

  List<Note> searchNotes(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    return _notes.where((n) =>
      n.title.toLowerCase().contains(q) ||
      n.content.toLowerCase().contains(q) ||
      n.category.toLowerCase().contains(q) ||
      n.tags.any((t) => t.toLowerCase().contains(q))).toList();
  }

  List<Note> getRelatedNotesForNode(MemoryNode node) => _notes.where((n) {
    final cat = n.category.toLowerCase() == node.category.toLowerCase();
    final tag = n.tags.any((t) => t.toLowerCase() == node.label.toLowerCase());
    final title = n.title.toLowerCase().contains(node.label.toLowerCase());
    return cat || tag || title;
  }).toList();

  List<Note> getRelatedNotes(Note note) => _notes.where((n) {
    if (n.id == note.id) return false;
    return n.category == note.category || n.tags.any((t) => note.tags.contains(t));
  }).take(4).toList();

  void addNote(Note note) { _notes.insert(0, note); notifyListeners(); _persist(); }

  void updateNote(Note updated) {
    final index = _notes.indexWhere((n) => n.id == updated.id);
    if (index != -1) { _notes[index] = updated; notifyListeners(); _persist(); }
  }

  void deleteNote(String id) { _notes.removeWhere((n) => n.id == id); notifyListeners(); _persist(); }

  void toggleFavorite(String id) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) { _notes[index].isFavorite = !_notes[index].isFavorite; notifyListeners(); _persist(); }
  }

  void setSelectedCategory(String category) { _selectedCategory = category; notifyListeners(); }
  void setSortOption(NoteSortOption option) { _sortOption = option; notifyListeners(); }
  void setSearchQuery(String query) { _searchQuery = query; notifyListeners(); }
  void selectNode(MemoryNode? node) { _selectedNode = node; notifyListeners(); }

  void addMood(String emoji, String label, String note) {
    _moods.insert(0, MoodEntry(
      id: 'mood-${DateTime.now().millisecondsSinceEpoch}',
      emoji: emoji,
      label: label,
      note: note,
      date: DateTime.now(),
    ));
    notifyListeners();
    _persist();
  }

  void addCapsule(String title, String message, DateTime unlockDate) {
    _capsules.insert(0, TimeCapsule(
      id: 'capsule-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      createdAt: DateTime.now(),
      unlockDate: unlockDate,
      isOpened: false,
    ));
    notifyListeners();
    _persist();
  }

  void unlockCapsule(String id) {
    final index = _capsules.indexWhere((c) => c.id == id);
    if (index != -1) { _capsules[index].isOpened = true; notifyListeners(); _persist(); }
  }

  void setThemeMode(ThemeMode mode) { _themeMode = mode; notifyListeners(); _persist(); }
  void setAccentColor(Color color) { _accentColor = color; notifyListeners(); _persist(); }

  void resetData() { _initializeData(); notifyListeners(); _persist(); }

  void clearAllData() {
    _notes.clear();
    _moods.clear();
    _capsules.clear();
    notifyListeners();
    _persist();
  }
}
