import '../enums/quadrant_type.dart';

class NoteEntity {
  const NoteEntity({
    required this.id,
    required this.quadrantType,
    required this.title,
    required this.description,
    required this.dueAt,
    required this.isDone,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final QuadrantType quadrantType;
  final String title;
  final String? description;
  final DateTime? dueAt;
  final bool isDone;
  final double orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteEntity copyWith({
    QuadrantType? quadrantType,
    String? title,
    String? description,
    DateTime? dueAt,
    bool clearDueAt = false,
    bool? isDone,
    double? orderIndex,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id,
      quadrantType: quadrantType ?? this.quadrantType,
      title: title ?? this.title,
      description: description ?? this.description,
      dueAt: clearDueAt ? null : (dueAt ?? this.dueAt),
      isDone: isDone ?? this.isDone,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
