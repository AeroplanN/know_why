class Meaning {
  final int? id;
  final String title;
  final String? description;
  final String? imagePath;
  final String? audioPath;
  final DateTime createdAt;
  final DateTime? updatedAt;
  

  Meaning({
    this.id,
    required this.title,
    this.description,
    this.imagePath,
    this.audioPath,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_path': imagePath,
      'audio_path': audioPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Meaning.fromMap(Map<String, dynamic> map) {
    return Meaning(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      description: map['description'],
      imagePath: map['image_path'],
      audioPath: map['audio_path'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Meaning copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
    String? audioPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meaning(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Meaning(id: $id, title: $title, description: $description, imagePath: $imagePath, audioPath: $audioPath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}