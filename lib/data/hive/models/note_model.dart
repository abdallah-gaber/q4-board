import '../../../domain/entities/note_entity.dart';
import '../../../domain/enums/quadrant_type.dart';

class NoteModel {
  const NoteModel({
    required this.id,
    required this.quadrantType,
    required this.title,
    required this.description,
    required this.dueAt,
    required this.isDone,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
    this.needsRepair = false,
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
  final bool needsRepair;

  factory NoteModel.fromEntity(NoteEntity entity) => NoteModel(
    id: entity.id,
    quadrantType: entity.quadrantType,
    title: entity.title,
    description: entity.description,
    dueAt: entity.dueAt,
    isDone: entity.isDone,
    orderIndex: entity.orderIndex,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  NoteEntity toEntity() => NoteEntity(
    id: id,
    quadrantType: quadrantType,
    title: title,
    description: description,
    dueAt: dueAt,
    isDone: isDone,
    orderIndex: orderIndex,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  NoteModel copyWith({
    String? id,
    QuadrantType? quadrantType,
    String? title,
    String? description,
    DateTime? dueAt,
    bool clearDueAt = false,
    bool? isDone,
    double? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? needsRepair,
  }) {
    return NoteModel(
      id: id ?? this.id,
      quadrantType: quadrantType ?? this.quadrantType,
      title: title ?? this.title,
      description: description ?? this.description,
      dueAt: clearDueAt ? null : (dueAt ?? this.dueAt),
      isDone: isDone ?? this.isDone,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      needsRepair: needsRepair ?? this.needsRepair,
    );
  }
}
