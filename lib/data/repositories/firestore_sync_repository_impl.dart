import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/enums/quadrant_type.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/sync_repository.dart';
import '../services/note_sync_merge_planner.dart';

class FirestoreSyncRepositoryImpl implements SyncRepository {
  static const int _maxBatchOperations = 450;
  static const int _maxTitleLength = 160;
  static const int _maxDescriptionLength = 2000;

  FirestoreSyncRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required NoteRepository localNoteRepository,
  }) : _firestore = firestore,
       _auth = auth,
       _localNoteRepository = localNoteRepository {
    _statusController.add(SyncStatusSnapshot.idle);
  }

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final NoteRepository _localNoteRepository;
  final StreamController<SyncStatusSnapshot> _statusController =
      StreamController<SyncStatusSnapshot>.broadcast();

  SyncStatusSnapshot _latest = SyncStatusSnapshot.idle;

  @override
  Stream<SyncStatusSnapshot> watchStatus() {
    return Stream<SyncStatusSnapshot>.multi((multi) {
      multi.add(_latest);
      final sub = _statusController.stream.listen(multi.add);
      multi.onCancel = sub.cancel;
    });
  }

  @override
  Future<SyncOperationResult> push() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _emit(const SyncStatusSnapshot(code: SyncStatusCode.authRequired));
      throw StateError('Authentication required.');
    }

    _emit(const SyncStatusSnapshot(code: SyncStatusCode.pushing));
    try {
      final localNotes = await _localNoteRepository.getAllNotes();
      final remoteNotes = await _fetchRemoteNotes(uid);
      final plan = NoteSyncMergePlanner.buildPushPlan(
        localNotes: localNotes,
        remoteNotes: remoteNotes,
      );

      await _commitPushPlan(uid, plan);

      final now = DateTime.now();
      _emit(
        SyncStatusSnapshot(
          code: SyncStatusCode.success,
          lastMessage: plan.skippedConflicts > 0
              ? 'push_conflicts_skipped'
              : 'push_complete',
          lastSuccessAt: now,
        ),
      );

      return SyncOperationResult(
        upserts: plan.upserts.length,
        deletes: plan.deletes.length,
        skippedConflicts: plan.skippedConflicts,
        didMutate: plan.upserts.isNotEmpty || plan.deletes.isNotEmpty,
      );
    } catch (error) {
      _emit(
        SyncStatusSnapshot(
          code: SyncStatusCode.error,
          lastMessage: error.toString(),
          lastSuccessAt: _latest.lastSuccessAt,
        ),
      );
      rethrow;
    }
  }

  @override
  Future<SyncOperationResult> pull() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _emit(const SyncStatusSnapshot(code: SyncStatusCode.authRequired));
      throw StateError('Authentication required.');
    }

    _emit(const SyncStatusSnapshot(code: SyncStatusCode.pulling));
    try {
      final localNotes = await _localNoteRepository.getAllNotes();
      final remoteNotes = await _fetchRemoteNotes(uid);
      final plan = NoteSyncMergePlanner.buildPullPlan(
        localNotes: localNotes,
        remoteNotes: remoteNotes,
      );

      for (final note in plan.upserts) {
        await _localNoteRepository.upsert(note);
      }
      for (final id in plan.deletes) {
        await _localNoteRepository.deleteById(id);
      }

      final now = DateTime.now();
      _emit(
        SyncStatusSnapshot(
          code: SyncStatusCode.success,
          lastMessage: plan.skippedEmptyRemoteDelete
              ? 'pull_remote_empty_local_kept'
              : (plan.skippedConflicts > 0
                    ? 'pull_conflicts_skipped'
                    : 'pull_complete'),
          lastSuccessAt: now,
        ),
      );

      return SyncOperationResult(
        upserts: plan.upserts.length,
        deletes: plan.deletes.length,
        skippedConflicts: plan.skippedConflicts,
        didMutate: plan.upserts.isNotEmpty || plan.deletes.isNotEmpty,
      );
    } catch (error) {
      _emit(
        SyncStatusSnapshot(
          code: SyncStatusCode.error,
          lastMessage: error.toString(),
          lastSuccessAt: _latest.lastSuccessAt,
        ),
      );
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> _notesCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('notes');
  }

  Future<Map<String, NoteEntity>> _fetchRemoteNotes(String uid) async {
    final snapshot = await _notesCollection(uid).get();
    final result = <String, NoteEntity>{};
    for (final doc in snapshot.docs) {
      final note = _fromMap(doc.id, doc.data());
      if (note != null) {
        result[doc.id] = note;
      }
    }
    return result;
  }

  Map<String, dynamic> _toMap(NoteEntity note) {
    final title = note.title.trim();
    if (title.isEmpty) {
      throw StateError('Cannot sync note with empty title.');
    }
    if (title.length > _maxTitleLength) {
      throw StateError('Cannot sync note title longer than $_maxTitleLength.');
    }
    final description = note.description?.trim();
    if (description != null && description.length > _maxDescriptionLength) {
      throw StateError(
        'Cannot sync note description longer than $_maxDescriptionLength.',
      );
    }
    final orderIndex = note.orderIndex.isFinite ? note.orderIndex : 0.0;

    return <String, dynamic>{
      'quadrantType': note.quadrantType.name,
      'title': title,
      'description': (description == null || description.isEmpty)
          ? null
          : description,
      'dueAt': note.dueAt == null ? null : Timestamp.fromDate(note.dueAt!),
      'isDone': note.isDone,
      'orderIndex': orderIndex,
      'createdAt': Timestamp.fromDate(note.createdAt),
      'updatedAt': Timestamp.fromDate(note.updatedAt),
    };
  }

  NoteEntity? _fromMap(String id, Map<String, dynamic> data) {
    final quadrant = QuadrantTypeX.tryParse(data['quadrantType'] as String?);
    final title = data['title'];
    if (quadrant == null || title is! String || title.trim().isEmpty) {
      return null;
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is DateTime) {
        return value;
      }
      return null;
    }

    final trimmedTitle = title.trim();
    if (trimmedTitle.length > _maxTitleLength) {
      return null;
    }

    final createdAt = parseDate(data['createdAt']) ?? DateTime.now();
    final updatedAt = parseDate(data['updatedAt']) ?? createdAt;
    final dueAt = parseDate(data['dueAt']);
    final description = data['description'] as String?;
    final orderValue = data['orderIndex'];
    final normalizedDescription = description?.trim();
    if (normalizedDescription != null &&
        normalizedDescription.length > _maxDescriptionLength) {
      return null;
    }
    final orderIndex = orderValue is num && orderValue.toDouble().isFinite
        ? orderValue.toDouble()
        : 0.0;

    return NoteEntity(
      id: id,
      quadrantType: quadrant,
      title: trimmedTitle,
      description: (normalizedDescription?.isEmpty ?? true)
          ? null
          : normalizedDescription,
      dueAt: dueAt,
      isDone: data['isDone'] as bool? ?? false,
      orderIndex: orderIndex,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Future<void> _commitPushPlan(String uid, SyncMergePlan plan) async {
    if (plan.upserts.isEmpty && plan.deletes.isEmpty) {
      return;
    }
    final collection = _notesCollection(uid);
    final operations = <_SyncWriteOp>[
      ...plan.upserts.map((note) => _SyncWriteOp.upsert(note.id, _toMap(note))),
      ...plan.deletes.map(_SyncWriteOp.delete),
    ];

    for (
      var start = 0;
      start < operations.length;
      start += _maxBatchOperations
    ) {
      final end = (start + _maxBatchOperations).clamp(0, operations.length);
      final batch = _firestore.batch();
      for (final op in operations.sublist(start, end)) {
        final doc = collection.doc(op.noteId);
        if (op.delete) {
          batch.delete(doc);
        } else {
          batch.set(doc, op.data!);
        }
      }
      await batch.commit();
    }
  }

  void _emit(SyncStatusSnapshot snapshot) {
    _latest = snapshot;
    _statusController.add(snapshot);
  }
}

class _SyncWriteOp {
  const _SyncWriteOp._({required this.noteId, required this.delete, this.data});

  final String noteId;
  final bool delete;
  final Map<String, dynamic>? data;

  factory _SyncWriteOp.upsert(String noteId, Map<String, dynamic> data) =>
      _SyncWriteOp._(noteId: noteId, delete: false, data: data);

  factory _SyncWriteOp.delete(String noteId) =>
      _SyncWriteOp._(noteId: noteId, delete: true);
}

class UnavailableSyncRepository implements SyncRepository {
  const UnavailableSyncRepository();

  @override
  Stream<SyncStatusSnapshot> watchStatus() =>
      Stream<SyncStatusSnapshot>.value(SyncStatusSnapshot.unavailable);

  @override
  Future<SyncOperationResult> pull() async {
    throw StateError('Cloud sync is not available.');
  }

  @override
  Future<SyncOperationResult> push() async {
    throw StateError('Cloud sync is not available.');
  }
}
