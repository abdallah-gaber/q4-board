import '../entities/note_entity.dart';

abstract interface class NoteRepository {
  Stream<List<NoteEntity>> watchNotes();

  Future<List<NoteEntity>> getAllNotes();

  Future<NoteEntity?> getById(String id);

  Future<void> upsert(NoteEntity note);

  Future<void> deleteById(String id);
}
