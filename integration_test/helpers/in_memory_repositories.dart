import 'dart:async';

import 'package:q4_board/domain/entities/app_settings_entity.dart';
import 'package:q4_board/domain/entities/note_entity.dart';
import 'package:q4_board/domain/repositories/note_repository.dart';
import 'package:q4_board/domain/repositories/settings_repository.dart';

class InMemoryNoteRepository implements NoteRepository {
  final List<NoteEntity> _notes = <NoteEntity>[];
  final StreamController<List<NoteEntity>> _changes =
      StreamController<List<NoteEntity>>.broadcast();

  @override
  Stream<List<NoteEntity>> watchNotes() {
    return Stream<List<NoteEntity>>.multi((multi) {
      multi.add(_sorted());
      final sub = _changes.stream.listen(multi.add);
      multi.onCancel = sub.cancel;
    });
  }

  @override
  Future<List<NoteEntity>> getAllNotes() async => _sorted();

  @override
  Future<NoteEntity?> getById(String id) async {
    for (final note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  @override
  Future<void> upsert(NoteEntity note) async {
    final index = _notes.indexWhere((item) => item.id == note.id);
    if (index == -1) {
      _notes.add(note);
    } else {
      _notes[index] = note;
    }
    _changes.add(_sorted());
  }

  @override
  Future<void> deleteById(String id) async {
    _notes.removeWhere((note) => note.id == id);
    _changes.add(_sorted());
  }

  List<NoteEntity> _sorted() {
    final cloned = [..._notes];
    cloned.sort((a, b) {
      final byQuadrant = a.quadrantType.index.compareTo(b.quadrantType.index);
      if (byQuadrant != 0) return byQuadrant;
      return a.orderIndex.compareTo(b.orderIndex);
    });
    return cloned;
  }

  Future<void> dispose() async => _changes.close();
}

class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository({AppSettingsEntity? initial})
    : _settings = initial ?? AppSettingsEntity.defaults();

  AppSettingsEntity _settings;
  final StreamController<AppSettingsEntity> _changes =
      StreamController<AppSettingsEntity>.broadcast();

  @override
  Stream<AppSettingsEntity> watchSettings() {
    return Stream<AppSettingsEntity>.multi((multi) {
      multi.add(_settings);
      final sub = _changes.stream.listen(multi.add);
      multi.onCancel = sub.cancel;
    });
  }

  @override
  Future<AppSettingsEntity> getSettings() async => _settings;

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {
    _settings = settings;
    _changes.add(settings);
  }

  Future<void> dispose() async => _changes.close();
}
