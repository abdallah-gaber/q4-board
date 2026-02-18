import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/local/hive_local_datasource.dart';
import '../hive/models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._dataSource);

  final HiveLocalDataSource _dataSource;

  @override
  Stream<List<NoteEntity>> watchNotes() {
    return Stream<List<NoteEntity>>.multi((multi) async {
      multi.add(_readSorted());
      await for (final _ in _dataSource.notesBox.watch()) {
        multi.add(_readSorted());
      }
    });
  }

  @override
  Future<List<NoteEntity>> getAllNotes() async => _readSorted();

  @override
  Future<NoteEntity?> getById(String id) async {
    final model = _dataSource.notesBox.get(id);
    return model?.toEntity();
  }

  @override
  Future<void> upsert(NoteEntity note) async {
    await _dataSource.notesBox.put(note.id, NoteModel.fromEntity(note));
  }

  @override
  Future<void> deleteById(String id) async {
    await _dataSource.notesBox.delete(id);
  }

  List<NoteEntity> _readSorted() {
    final notes = _dataSource.notesBox.values
        .map((model) => model.toEntity())
        .toList(growable: false);
    notes.sort((a, b) {
      final byQuadrant = a.quadrantType.index.compareTo(b.quadrantType.index);
      if (byQuadrant != 0) {
        return byQuadrant;
      }
      return a.orderIndex.compareTo(b.orderIndex);
    });
    return notes;
  }
}
