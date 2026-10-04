import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/mood.dart';
import '../models/capsule.dart';
import '../models/connection.dart';
import '../data/mock_data.dart';

enum NoteSortOption { newest, oldest, alphabetical, mostLoved }

class AppProvider with ChangeNotifier {
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
  }

  void _initializeData() {
    _notes = MockData.getInitialNotes();
    _moods = MockData.getInitialMoods();
    _capsules = MockData.getInitialCapsules();
    _nodes = MockData.getInitialNodes();
    _edges = MockData.getInitialEdges();
  }

  // Getters
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

  // Statistics (combines mock baseline with live user additions)
  int get totalMemoriesCount => 120 + _notes.length;
  int get ideasCount => 20 + _notes.where((n) => n.category == 'Ideas' || n.type == 'idea').length;
  int get reflectionsCount => 14 + _notes.where((n) => n.type == 'reflection').length;
  int get favoritesCount => _notes.where((n) => n.isFavorite).length;
  int get capsulesCount => _capsules.length;

  MoodEntry? get todayMood {
    if (_moods.isEmpty) return null;
    return _moods.first;
  }

  Note? get onThisDayNote {
    // Return nostalgic note
    final past = _notes.where((n) => n.tags.contains('Nostalgia') || n.tags.contains('Milestone'));
    if (past.isNotEmpty) return past.first;
    return _notes.isNotEmpty ? _notes.last : null;
  }

  List<Note> get recentNotes {
    final sorted = List<Note>.from(_notes)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(5).toList();
  }

  List<Note> get filteredVaultNotes {
    var result = List<Note>.from(_notes);

    // Filter by Category
    if (_selectedCategory != 'All') {
      result = result.where((n) => n.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((n) {
        final inTitle = n.title.toLowerCase().contains(query);
        final inContent = n.content.toLowerCase().contains(query);
        final inCategory = n.category.toLowerCase().contains(query);
        final inTags = n.tags.any((t) => t.toLowerCase().contains(query));
        return inTitle || inContent || inCategory || inTags;
      }).toList();
    }

    // Apply Sorting
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
    return _notes.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q) ||
          n.category.toLowerCase().contains(q) ||
          n.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  List<Note> getRelatedNotesForNode(MemoryNode node) {
    return _notes.where((n) {
      final matchesCat = n.category.toLowerCase() == node.category.toLowerCase();
      final matchesTag = n.tags.any((t) => t.toLowerCase() == node.label.toLowerCase());
      final matchesTitle = n.title.toLowerCase().contains(node.label.toLowerCase());
      return matchesCat || matchesTag || matchesTitle;
    }).toList();
  }

  List<Note> getRelatedNotes(Note note) {
    return _notes.where((n) {
      if (n.id == note.id) return false;
      final sameCat = n.category == note.category;
      final sharedTags = n.tags.any((t) => note.tags.contains(t));
      return sameCat || sharedTags;
    }).take(4).toList();
  }

  // Mutations
  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void updateNote(Note updated) {
    final index = _notes.indexWhere((n) => n.id == updated.id);
    if (index != -1) {
      _notes[index] = updated;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].isFavorite = !_notes[index].isFavorite;
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(NoteSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectNode(MemoryNode? node) {
    _selectedNode = node;
    notifyListeners();
  }

  void addMood(String emoji, String label, String note) {
    final newEntry = MoodEntry(
      id: 'mood-${DateTime.now().millisecondsSinceEpoch}',
      emoji: emoji,
      label: label,
      note: note,
      date: DateTime.now(),
    );
    _moods.insert(0, newEntry);
    notifyListeners();
  }

  void addCapsule(String title, String message, DateTime unlockDate) {
    final newCapsule = TimeCapsule(
      id: 'capsule-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      createdAt: DateTime.now(),
      unlockDate: unlockDate,
      isOpened: false,
    );
    _capsules.insert(0, newCapsule);
    notifyListeners();
  }

  void unlockCapsule(String id) {
    final index = _capsules.indexWhere((c) => c.id == id);
    if (index != -1) {
      _capsules[index].isOpened = true;
      notifyListeners();
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }

  void resetData() {
    _initializeData();
    notifyListeners();
  }

  void clearAllData() {
    _notes.clear();
    _moods.clear();
    _capsules.clear();
    notifyListeners();
  }
}
