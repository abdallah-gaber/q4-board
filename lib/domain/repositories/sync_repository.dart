enum SyncStatusCode {
  unavailable,
  idle,
  authRequired,
  liveListening,
  pushing,
  pulling,
  success,
  error,
}

class SyncStatusSnapshot {
  const SyncStatusSnapshot({
    required this.code,
    this.lastMessage,
    this.lastSuccessAt,
  });

  final SyncStatusCode code;
  final String? lastMessage;
  final DateTime? lastSuccessAt;

  static const unavailable = SyncStatusSnapshot(
    code: SyncStatusCode.unavailable,
  );
  static const idle = SyncStatusSnapshot(code: SyncStatusCode.idle);

  SyncStatusSnapshot copyWith({
    SyncStatusCode? code,
    String? lastMessage,
    bool clearLastMessage = false,
    DateTime? lastSuccessAt,
  }) {
    return SyncStatusSnapshot(
      code: code ?? this.code,
      lastMessage: clearLastMessage ? null : (lastMessage ?? this.lastMessage),
      lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
    );
  }
}

class SyncOperationResult {
  const SyncOperationResult({
    required this.upserts,
    required this.deletes,
    required this.skippedConflicts,
    required this.didMutate,
    this.conflictNoteIds = const <String>[],
  });

  final int upserts;
  final int deletes;
  final int skippedConflicts;
  final bool didMutate;
  final List<String> conflictNoteIds;
}

abstract interface class SyncRepository {
  Stream<SyncStatusSnapshot> watchStatus();

  Future<SyncOperationResult> push();

  Future<SyncOperationResult> pull();

  Future<void> startLiveSync();

  Future<void> stopLiveSync();
}
