import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:q4_board/data/hive/adapters/app_settings_model_adapter.dart';
import 'package:q4_board/data/hive/adapters/note_model_adapter.dart';
import 'package:q4_board/data/hive/adapters/quadrant_type_adapter.dart';
import 'package:q4_board/data/hive/hive_initializer.dart';
import 'package:q4_board/data/hive/models/app_settings_model.dart';
import 'package:q4_board/data/hive/models/note_model.dart';
import 'package:q4_board/data/services/local_data_maintenance_service.dart';
import 'package:q4_board/domain/enums/quadrant_type.dart';

void main() {
  late LocalDataMaintenanceService service;

  setUpAll(() async {
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

    await Hive.openBox<NoteModel>(HiveInitializer.notesBoxName);
    await Hive.openBox<AppSettingsModel>(HiveInitializer.settingsBoxName);
  });

  setUp(() async {
    service = const LocalDataMaintenanceService();
    await Hive.box<NoteModel>(HiveInitializer.notesBoxName).clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await tearDownTestHive();
  });

  test(
    'loadDemoData inserts deterministic seeded notes across quadrants',
    () async {
      final inserted = await service.loadDemoData();
      final now = DateTime.now();

      final notes = Hive.box<NoteModel>(
        HiveInitializer.notesBoxName,
      ).values.toList();

      expect(inserted, 8);
      expect(notes, hasLength(8));

      for (final quadrant in QuadrantType.values) {
        expect(
          notes.where((note) => note.quadrantType == quadrant).length,
          greaterThanOrEqualTo(2),
        );
      }

      expect(
        notes.where((note) => note.isDone).length,
        greaterThanOrEqualTo(2),
      );

      final dueNotes = notes.where((note) => note.dueAt != null).toList();
      expect(dueNotes.length, greaterThanOrEqualTo(2));
      expect(dueNotes.any((note) => note.dueAt!.isBefore(now)), isTrue);
      expect(dueNotes.any((note) => note.dueAt!.isAfter(now)), isTrue);
    },
  );
}
