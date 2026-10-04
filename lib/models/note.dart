class Note {
  final String id;
  String title;
  String content;
  String category;
  String mood;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  List<String> tags;
  String? type; // 'note', 'idea', 'task', 'reflection', 'voice', 'photo'

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.mood,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    required this.tags,
    this.type = 'note',
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? mood,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    List<String>? tags,
    String? type,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? List<String>.from(this.tags),
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'category': category,
    'mood': mood,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isFavorite': isFavorite,
    'tags': tags,
    'type': type,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    category: json['category'] as String,
    mood: json['mood'] as String? ?? '😊',
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    isFavorite: json['isFavorite'] as bool? ?? false,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    type: json['type'] as String? ?? 'note',
  );
}
