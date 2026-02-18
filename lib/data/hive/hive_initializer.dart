import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'adapters/app_settings_model_adapter.dart';
import 'adapters/note_model_adapter.dart';
import 'adapters/quadrant_type_adapter.dart';
import 'models/app_settings_model.dart';
import 'models/note_model.dart';

abstract final class HiveInitializer {
  static const int currentSchemaVersion = 2;

  static const String notesBoxName = 'notes_box_v1';
  static const String settingsBoxName = 'settings_box_v1';
  static const String metaBoxName = 'meta_box';
  static const String schemaVersionKey = 'schema_version';

  static bool recoveredCorruptedBoxes = false;
  static int repairedNotesCount = 0;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    _registerAdapters();

    final metaBox = await Hive.openBox<int>(metaBoxName);
    final existingVersion = metaBox.get(schemaVersionKey) ?? 0;
    if (existingVersion < currentSchemaVersion) {
      await _runMigrations(existingVersion, currentSchemaVersion);
      await metaBox.put(schemaVersionKey, currentSchemaVersion);
    }

    await _openBoxesSafely();
    await repairInvalidNotes();
  }

  static Future<void> resetLocalData() async {
    if (!Hive.isBoxOpen(notesBoxName)) {
      await Hive.openBox<NoteModel>(notesBoxName);
    }
    if (!Hive.isBoxOpen(settingsBoxName)) {
      await Hive.openBox<AppSettingsModel>(settingsBoxName);
    }
    if (!Hive.isBoxOpen(metaBoxName)) {
      await Hive.openBox<int>(metaBoxName);
    }

    await Hive.box<NoteModel>(notesBoxName).clear();
    await Hive.box<AppSettingsModel>(settingsBoxName).clear();
    await Hive.box<int>(
      metaBoxName,
    ).put(schemaVersionKey, currentSchemaVersion);
  }

  static Future<void> repairInvalidNotes() async {
    final notesBox = Hive.box<NoteModel>(notesBoxName);
    var repaired = 0;

    for (final key in notesBox.keys) {
      final value = notesBox.get(key);
      if (value == null || !value.needsRepair) {
        continue;
      }

      final repairedValue = value.copyWith(
        needsRepair: false,
        updatedAt: DateTime.now(),
      );

      await notesBox.put(key, repairedValue);
      repaired += 1;
    }

    repairedNotesCount = repaired;

    if (repaired > 0) {
      debugPrint('Q4Board: repaired $repaired corrupted note record(s).');
    }
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(QuadrantTypeAdapter().typeId)) {
      Hive.registerAdapter(QuadrantTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(NoteModelAdapter().typeId)) {
      Hive.registerAdapter(NoteModelAdapter());
    }
    if (!Hive.isAdapterRegistered(AppSettingsModelAdapter().typeId)) {
      Hive.registerAdapter(AppSettingsModelAdapter());
    }
  }

  static Future<void> _openBoxesSafely() async {
    await _openBoxWithRecovery<NoteModel>(notesBoxName);
    await _openBoxWithRecovery<AppSettingsModel>(settingsBoxName);
  }

  static Future<void> _openBoxWithRecovery<T>(String boxName) async {
    try {
      await Hive.openBox<T>(boxName);
    } catch (error, stackTrace) {
      recoveredCorruptedBoxes = true;
      debugPrint(
        'Q4Board: failed to open Hive box "$boxName". '
        'Attempting controlled recovery by clearing corrupted box. '
        'Error: $error\n$stackTrace',
      );

      if (Hive.isBoxOpen(boxName)) {
        await Hive.box<dynamic>(boxName).close();
      }
      await Hive.deleteBoxFromDisk(boxName);
      await Hive.openBox<T>(boxName);
    }
  }

  static Future<void> _runMigrations(int fromVersion, int toVersion) async {
    // Reserved for explicit schema migrations.
    if (fromVersion >= toVersion) {
      return;
    }
  }
}
