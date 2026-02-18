import 'package:hive/hive.dart';

import '../../../domain/enums/quadrant_type.dart';
import '../hive_type_ids.dart';

class QuadrantTypeAdapter extends TypeAdapter<QuadrantType> {
  @override
  final int typeId = HiveTypeIds.quadrantType;

  @override
  QuadrantType read(BinaryReader reader) {
    return QuadrantType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, QuadrantType obj) {
    writer.writeByte(obj.index);
  }
}
