import '../../domain/entities/note_entity.dart';

class SyncMergePlan {
  const SyncMergePlan({
    required this.upserts,
    required this.deletes,
    required this.skippedConflicts,
    this.skippedEmptyRemoteDelete = false,
  });

  final List<NoteEntity> upserts;
  final List<String> deletes;
  final int skippedConflicts;
  final bool skippedEmptyRemoteDelete;
}

class NoteSyncMergePlanner {
  const NoteSyncMergePlanner._();

  static SyncMergePlan buildPushPlan({
    required List<NoteEntity> localNotes,
    required Map<String, NoteEntity> remoteNotes,
  }) {
    final upserts = <NoteEntity>[];
    var skippedConflicts = 0;

    final localIds = <String>{};
    for (final local in localNotes) {
      localIds.add(local.id);
      final remote = remoteNotes[local.id];
      if (remote == null || !remote.updatedAt.isAfter(local.updatedAt)) {
        upserts.add(local);
      } else {
        skippedConflicts += 1;
      }
    }

    final deletes = remoteNotes.keys
        .where((id) => !localIds.contains(id))
        .toList(growable: false);

    return SyncMergePlan(
      upserts: upserts,
      deletes: deletes,
      skippedConflicts: skippedConflicts,
    );
  }

  static SyncMergePlan buildPullPlan({
    required List<NoteEntity> localNotes,
    required Map<String, NoteEntity> remoteNotes,
  }) {
    final localById = {for (final note in localNotes) note.id: note};
    final upserts = <NoteEntity>[];
    var skippedConflicts = 0;

    for (final remote in remoteNotes.values) {
      final local = localById[remote.id];
      if (local == null || !local.updatedAt.isAfter(remote.updatedAt)) {
        upserts.add(remote);
      } else {
        skippedConflicts += 1;
      }
    }

    final localIds = localById.keys.toSet();
    final remoteIds = remoteNotes.keys.toSet();

    // Safety: avoid deleting local notes when cloud is empty. This protects
    // first-time sign-in or an uninitialized remote workspace from wiping data.
    if (remoteIds.isEmpty && localIds.isNotEmpty) {
      return SyncMergePlan(
        upserts: upserts,
        deletes: const <String>[],
        skippedConflicts: skippedConflicts,
        skippedEmptyRemoteDelete: true,
      );
    }

    final deletes = localIds
        .where((id) => !remoteIds.contains(id))
        .toList(growable: false);

    return SyncMergePlan(
      upserts: upserts,
      deletes: deletes,
      skippedConflicts: skippedConflicts,
    );
  }
}
