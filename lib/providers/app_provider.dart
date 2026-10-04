import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const _dataVersionKey = 'mindvault.dataVersion';
  static const _currentDataVersion = 2;

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

  late final Future<void> _ready;
  Future<void> _writeQueue = Future.value();

  AppProvider() {
    _ready = _loadPersistedData();
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
      final version = prefs.getInt(_dataVersionKey) ?? 0;

      if (version < _currentDataVersion) {
        _initializeData();
        await prefs.remove(_notesKey);
        await prefs.remove(_moodsKey);
        await prefs.remove(_capsulesKey);
        await prefs.setInt(_dataVersionKey, _currentDataVersion);
      } else {
        final notes = prefs.getString(_notesKey);
        final moods = prefs.getString(_moodsKey);
        final capsules = prefs.getString(_capsulesKey);

        if (notes != null && notes.isNotEmpty) {
          final decoded = jsonDecode(notes);
          if (decoded is List) {
            _notes = decoded
                .map((item) => Note.fromJson(Map<String, dynamic>.from(item as Map)))
                .toList();
          }
        }
        if (moods != null && moods.isNotEmpty) {
          final decoded = jsonDecode(moods);
          if (decoded is List) {
            _moods = decoded
                .map((item) => MoodEntry.fromJson(Map<String, dynamic>.from(item as Map)))
                .toList();
          }
        }
        if (capsules != null && capsules.isNotEmpty) {
          final decoded = jsonDecode(capsules);
          if (decoded is List) {
            _capsules = decoded
                .map((item) => TimeCapsule.fromJson(Map<String, dynamic>.from(item as Map)))
                .toList();
          }
        }
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
    } catch (e) {
      // Never replace already-created user data with an empty vault because of
      // a transient storage/decoding error.
      debugPrint('MindVault load error: $e');
    }
    notifyListeners();
  }

  Future<void> _persist() {
    // Serialize writes. This prevents a slower older write from overwriting a
    // newer memory when the user saves several memories quickly.
    _writeQueue = _writeQueue.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          _notesKey,
          jsonEncode(_notes.map((n) => n.toJson()).toList()),
        );
        await prefs.setString(
          _moodsKey,
          jsonEncode(_moods.map((m) => m.toJson()).toList()),
        );
        await prefs.setString(
          _capsulesKey,
          jsonEncode(_capsules.map((c) => c.toJson()).toList()),
        );
        await prefs.setInt(_dataVersionKey, _currentDataVersion);
        await prefs.setString(_themeKey, _themeMode.name);
        await prefs.setInt(_accentKey, _accentColor.value);
      } catch (e) {
        debugPrint('MindVault save error: $e');
        rethrow;
      }
    });
    return _writeQueue;
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

  int get totalMemoriesCount => _notes.length;
  int get ideasCount => _notes.where((n) => n.category == 'Ideas' || n.type == 'idea').length;
  int get reflectionsCount => _moods.length;
  int get favoritesCount => _notes.where((n) => n.isFavorite).length;
  int get capsulesCount => _capsules.length;
  MoodEntry? get todayMood => _moods.isEmpty ? null : _moods.first;

  Note? get onThisDayNote {
    final now = DateTime.now();
    final matching = _notes.where((n) => n.createdAt.month == now.month && n.createdAt.day == now.day);
    return matching.isEmpty ? null : matching.first;
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

  Future<void> addNote(Note note) async {
    await _ready;
    _notes.insert(0, note);
    notifyListeners();
    await _persist();
  }

  Future<void> updateNote(Note updated) async {
    await _ready;
    final index = _notes.indexWhere((n) => n.id == updated.id);
    if (index != -1) {
      _notes[index] = updated;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> deleteNote(String id) async {
    await _ready;
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> toggleFavorite(String id) async {
    await _ready;
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].isFavorite = !_notes[index].isFavorite;
      notifyListeners();
      await _persist();
    }
  }

  void setSelectedCategory(String category) { _selectedCategory = category; notifyListeners(); }
  void setSortOption(NoteSortOption option) { _sortOption = option; notifyListeners(); }
  void setSearchQuery(String query) { _searchQuery = query; notifyListeners(); }
  void selectNode(MemoryNode? node) { _selectedNode = node; notifyListeners(); }

  Future<void> addMood(String emoji, String label, String note) async {
    await _ready;
    _moods.insert(0, MoodEntry(
      id: 'mood-${DateTime.now().millisecondsSinceEpoch}',
      emoji: emoji,
      label: label,
      note: note,
      date: DateTime.now(),
    ));
    notifyListeners();
    await _persist();
  }

  Future<void> addCapsule(String title, String message, DateTime unlockDate) async {
    await _ready;
    _capsules.insert(0, TimeCapsule(
      id: 'capsule-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      createdAt: DateTime.now(),
      unlockDate: unlockDate,
      isOpened: false,
    ));
    notifyListeners();
    await _persist();
  }

  Future<void> unlockCapsule(String id) async {
    await _ready;
    final index = _capsules.indexWhere((c) => c.id == id);
    if (index != -1) {
      _capsules[index].isOpened = true;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _ready;
    _themeMode = mode;
    notifyListeners();
    await _persist();
  }

  Future<void> setAccentColor(Color color) async {
    await _ready;
    _accentColor = color;
    notifyListeners();
    await _persist();
  }

  void resetData() { clearAllData(); }

  Future<void> clearAllData() async {
    await _ready;
    _notes.clear();
    _moods.clear();
    _capsules.clear();
    _nodes.clear();
    _edges.clear();
    _selectedNode = null;
    notifyListeners();
    await _persist();
  }
}
