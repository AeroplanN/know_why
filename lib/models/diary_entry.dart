class DiaryEntry {
  final int? id;
  final DateTime date;
  final int moodRating; // 1-10 scale
  final String? note;
  final DateTime createdAt;

  DiaryEntry({
    this.id,
    required this.date,
    required this.moodRating,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0], // Только дата без времени
      'mood_rating': moodRating,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id']?.toInt(),
      date: DateTime.parse(map['date']),
      moodRating: map['mood_rating']?.toInt() ?? 1,
      note: map['note'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  DiaryEntry copyWith({
    int? id,
    DateTime? date,
    int? moodRating,
    String? note,
    DateTime? createdAt,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      moodRating: moodRating ?? this.moodRating,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'DiaryEntry(id: $id, date: $date, moodRating: $moodRating, note: $note, createdAt: $createdAt)';
  }
}