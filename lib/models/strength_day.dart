class StrengthDay {
  final int? id;
  final DateTime date;
  final String? note;
  final String? imagePath;
  final DateTime createdAt;

  StrengthDay({
    this.id,
    required this.date,
    this.note,
    this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0], // Только дата без времени
      'note': note,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory StrengthDay.fromMap(Map<String, dynamic> map) {
    return StrengthDay(
      id: map['id']?.toInt(),
      date: DateTime.parse(map['date']),
      note: map['note'],
      imagePath: map['image_path'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  StrengthDay copyWith({
    int? id,
    DateTime? date,
    String? note,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return StrengthDay(
      id: id ?? this.id,
      date: date ?? this.date,
      note: note ?? this.note,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'StrengthDay(id: $id, date: $date, note: $note, imagePath: $imagePath, createdAt: $createdAt)';
  }
}