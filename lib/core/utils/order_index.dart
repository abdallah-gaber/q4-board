import '../../domain/entities/note_entity.dart';

abstract final class OrderIndex {
  static double forInsert(List<NoteEntity> sortedNotes, int index) {
    if (sortedNotes.isEmpty) {
      return 0;
    }
    if (index <= 0) {
      return sortedNotes.first.orderIndex - 1;
    }
    if (index >= sortedNotes.length) {
      return sortedNotes.last.orderIndex + 1;
    }
    final before = sortedNotes[index - 1].orderIndex;
    final after = sortedNotes[index].orderIndex;
    return (before + after) / 2;
  }
}
