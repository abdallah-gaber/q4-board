import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:q4_board/data/datasources/local/hive_local_datasource.dart';
import 'package:q4_board/data/hive/adapters/app_settings_model_adapter.dart';
import 'package:q4_board/data/hive/adapters/note_model_adapter.dart';
import 'package:q4_board/data/hive/adapters/quadrant_type_adapter.dart';
import 'package:q4_board/data/hive/hive_initializer.dart';
import 'package:q4_board/data/hive/models/app_settings_model.dart';
import 'package:q4_board/data/hive/models/note_model.dart';
import 'package:q4_board/data/repositories/note_repository_impl.dart';
import 'package:q4_board/data/repositories/settings_repository_impl.dart';
import 'package:q4_board/domain/entities/app_settings_entity.dart';
import 'package:q4_board/domain/entities/note_entity.dart';
import 'package:q4_board/domain/enums/app_language_mode.dart';
import 'package:q4_board/domain/enums/quadrant_type.dart';
import 'package:q4_board/domain/enums/theme_preference.dart';

void main() {
  late HiveLocalDataSource dataSource;
  late NoteRepositoryImpl noteRepository;
  late SettingsRepositoryImpl settingsRepository;

  Future<void> flush() => Future<void>.delayed(Duration.zero);

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

  setUp(() {
    dataSource = const HiveLocalDataSource();
    noteRepository = NoteRepositoryImpl(dataSource);
    settingsRepository = SettingsRepositoryImpl(dataSource);
  });

  tearDown(() async {
    await dataSource.notesBox.clear();
    await dataSource.settingsBox.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await tearDownTestHive();
  });

  test('note repository upsert and read are persisted and sorted', () async {
    final now = DateTime(2026, 1, 1);
    await noteRepository.upsert(
      NoteEntity(
        id: 'a',
        quadrantType: QuadrantType.inu,
        title: 'Second',
        description: null,
        dueAt: null,
        isDone: false,
        orderIndex: 10,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await noteRepository.upsert(
      NoteEntity(
        id: 'b',
        quadrantType: QuadrantType.iu,
        title: 'First',
        description: null,
        dueAt: null,
        isDone: false,
        orderIndex: 1,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final notes = await noteRepository.getAllNotes();

    expect(notes, hasLength(2));
    expect(notes.first.id, 'b');
  });

  test('note repository watch emits updates', () async {
    final events = <List<NoteEntity>>[];
    final sub = noteRepository.watchNotes().listen(events.add);

    await flush();
    expect(events.last, isEmpty);

    await noteRepository.upsert(
      NoteEntity(
        id: 'note-1',
        quadrantType: QuadrantType.iu,
        title: 'Task',
        description: null,
        dueAt: null,
        isDone: false,
        orderIndex: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await flush();
    expect(events.last, hasLength(1));

    await sub.cancel();
  });

  test('settings repository saves and reads settings', () async {
    final settings = AppSettingsEntity(
      themePreference: ThemePreference.dark,
      languageMode: AppLanguageMode.arabic,
      defaultShowDone: false,
    );

    await settingsRepository.saveSettings(settings);
    final read = await settingsRepository.getSettings();

    expect(read.themePreference, ThemePreference.dark);
    expect(read.languageMode, AppLanguageMode.arabic);
    expect(read.defaultShowDone, isFalse);
  });
}
