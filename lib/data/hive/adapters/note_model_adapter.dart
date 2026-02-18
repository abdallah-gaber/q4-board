import 'package:hive/hive.dart';

import '../../../domain/enums/quadrant_type.dart';
import '../hive_type_ids.dart';
import '../models/note_model.dart';

class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  final int typeId = HiveTypeIds.noteModel;

  @override
  NoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteModelAdapter.fromFields(fields);
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.quadrantType)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.dueAt)
      ..writeByte(5)
      ..write(obj.isDone)
      ..writeByte(6)
      ..write(obj.orderIndex)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  static NoteModel fromFields(Map<int, dynamic> fields) {
    final now = DateTime.now();
    var needsRepair = false;

    final rawId = fields[0];
    final id = switch (rawId) {
      String value when value.isNotEmpty => value,
      _ => 'recovered-${now.microsecondsSinceEpoch}',
    };
    if (id.startsWith('recovered-')) {
      needsRepair = true;
    }

    final quadrantDecoded = _decodeQuadrantType(fields[1]);
    final quadrantType = quadrantDecoded.quadrant;
    needsRepair = needsRepair || quadrantDecoded.needsRepair;

    final rawTitle = fields[2];
    final title = switch (rawTitle) {
      String value when value.trim().isNotEmpty => value,
      _ => 'Untitled',
    };
    if (title == 'Untitled') {
      needsRepair = true;
    }

    final rawDescription = fields[3];
    final description = rawDescription is String ? rawDescription : null;

    final rawDue = fields[4];
    final dueAt = rawDue is DateTime ? rawDue : null;
    if (rawDue != null && rawDue is! DateTime) {
      needsRepair = true;
    }

    final rawDone = fields[5];
    final isDone = rawDone is bool ? rawDone : false;
    if (rawDone != null && rawDone is! bool) {
      needsRepair = true;
    }

    final rawOrder = fields[6];
    final orderIndex = rawOrder is num ? rawOrder.toDouble() : 0.0;
    if (rawOrder != null && rawOrder is! num) {
      needsRepair = true;
    }

    final rawCreatedAt = fields[7];
    final createdAt = rawCreatedAt is DateTime ? rawCreatedAt : now;
    if (rawCreatedAt != null && rawCreatedAt is! DateTime) {
      needsRepair = true;
    }

    final rawUpdatedAt = fields[8];
    final updatedAt = rawUpdatedAt is DateTime ? rawUpdatedAt : createdAt;
    if (rawUpdatedAt != null && rawUpdatedAt is! DateTime) {
      needsRepair = true;
    }

    return NoteModel(
      id: id,
      quadrantType: quadrantType,
      title: title,
      description: description,
      dueAt: dueAt,
      isDone: isDone,
      orderIndex: orderIndex,
      createdAt: createdAt,
      updatedAt: updatedAt,
      needsRepair: needsRepair,
    );
  }

  static ({QuadrantType quadrant, bool needsRepair}) _decodeQuadrantType(
    dynamic value,
  ) {
    if (value is QuadrantType) {
      return (quadrant: value, needsRepair: false);
    }

    if (value is int && value >= 0 && value < QuadrantType.values.length) {
      return (quadrant: QuadrantType.values[value], needsRepair: true);
    }

    return (quadrant: QuadrantType.iu, needsRepair: true);
  }
}
