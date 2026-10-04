class TimeCapsule {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime unlockDate;
  bool isOpened;

  TimeCapsule({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.unlockDate,
    this.isOpened = false,
  });

  bool get isReadyToUnlock => DateTime.now().isAfter(unlockDate);

  int get daysRemaining {
    if (isReadyToUnlock) return 0;
    return unlockDate.difference(DateTime.now()).inDays + 1;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'unlockDate': unlockDate.toIso8601String(),
    'isOpened': isOpened,
  };

  factory TimeCapsule.fromJson(Map<String, dynamic> json) => TimeCapsule(
    id: json['id'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    unlockDate: DateTime.parse(json['unlockDate'] as String),
    isOpened: json['isOpened'] as bool? ?? false,
  );
}
