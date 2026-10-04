class MoodEntry {
  final String id;
  final String emoji;
  final String label;
  final String note;
  final DateTime date;

  MoodEntry({
    required this.id,
    required this.emoji,
    required this.label,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'emoji': emoji,
    'label': label,
    'note': note,
    'date': date.toIso8601String(),
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    id: json['id'] as String,
    emoji: json['emoji'] as String,
    label: json['label'] as String,
    note: json['note'] as String? ?? '',
    date: DateTime.parse(json['date'] as String),
  );
}
