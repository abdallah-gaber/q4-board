import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:q4_board/data/hive/adapters/app_settings_model_adapter.dart';
import 'package:q4_board/data/hive/adapters/note_model_adapter.dart';
import 'package:q4_board/data/hive/adapters/quadrant_type_adapter.dart';
import 'package:q4_board/data/hive/hive_initializer.dart';
import 'package:q4_board/data/hive/models/app_settings_model.dart';
import 'package:q4_board/data/hive/models/note_model.dart';
import 'package:q4_board/domain/enums/quadrant_type.dart';

void main() {
  group('NoteModelAdapter recovery', () {
    test('read falls back when quadrantType field is missing', () {
      final adapter = NoteModelAdapter();
      final now = DateTime(2026, 2, 18);
      final reader = _FakeBinaryReader(
        byteValues: <int>[8, 0, 2, 3, 4, 5, 6, 7, 8],
        dynamicValues: <dynamic>[
          'legacy-note',
          'Recovered title',
          null,
          null,
          false,
          42.0,
          now,
          now,
        ],
      );

      final model = adapter.read(reader);

      expect(model.id, 'legacy-note');
      expect(model.quadrantType, QuadrantType.iu);
      expect(model.needsRepair, isTrue);
    });

    test('repairInvalidNotes rewrites recovered records', () async {
      await setUpTestHive();

      if (!Hive.isAdapterRegistered(QuadrantTypeAdapter().typeId)) {
        Hive.registerAdapter(QuadrantTypeAdapter());
      }
      if (!Hive.isAdapterRegistered(NoteModelAdapter().typeId)) {
        Hive.registerAdapter(NoteModelAdapter());
      }
      if (!Hive.isAdapterRegistered(AppSettingsModelAdapter().typeId)) {
        Hive.registerAdapter(AppSettingsModelAdapter());
      }

      final notesBox = await Hive.openBox<NoteModel>(
        HiveInitializer.notesBoxName,
      );
      await Hive.openBox<AppSettingsModel>(HiveInitializer.settingsBoxName);

      final broken = NoteModel(
        id: 'broken-1',
        quadrantType: QuadrantType.iu,
        title: 'Recovered title',
        description: null,
        dueAt: null,
        isDone: false,
        orderIndex: 0,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        needsRepair: true,
      );

      await notesBox.put(broken.id, broken);

      await HiveInitializer.repairInvalidNotes();

      final repaired = notesBox.get(broken.id)!;
      expect(repaired.needsRepair, isFalse);
      expect(HiveInitializer.repairedNotesCount, 1);

      await Hive.close();
      await tearDownTestHive();
    });
  });
}

class _FakeBinaryReader implements BinaryReader {
  _FakeBinaryReader({required this.byteValues, required this.dynamicValues});

  final List<int> byteValues;
  final List<dynamic> dynamicValues;
  int _byteIndex = 0;
  int _valueIndex = 0;

  @override
  int readByte() => byteValues[_byteIndex++];

  @override
  dynamic read([int? typeId]) => dynamicValues[_valueIndex++];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
