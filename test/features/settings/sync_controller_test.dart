import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:q4_board/core/firebase/firebase_bootstrap.dart';
import 'package:q4_board/domain/repositories/sync_repository.dart';
import 'package:q4_board/domain/services/auth_service.dart';
import 'package:q4_board/features/settings/controllers/sync_controller.dart';

void main() {
  group('SyncController', () {
    test('records timeout error and clears busy state', () async {
      final controller = SyncController(
        authService: _FakeAuthService(),
        syncRepository: _NeverCompletesSyncRepository(),
        bootstrapState: const FirebaseBootstrapState(
          isAvailable: true,
          isConfigured: true,
        ),
        operationTimeout: const Duration(milliseconds: 10),
      );
      addTearDown(controller.dispose);

      expect(controller.state.isBusy, isFalse);

      await expectLater(controller.push(), throwsA(isA<TimeoutException>()));

      expect(controller.state.isBusy, isFalse);
      expect(controller.state.lastError, isNotNull);
      expect(controller.state.lastError!.isTimeout, isTrue);
      expect(controller.state.canRetryLastAction, isTrue);
    });

    test('retryLastAction reruns last failed action', () async {
      final repo = _FlakySyncRepository();
      final controller = SyncController(
        authService: _FakeAuthService(),
        syncRepository: repo,
        bootstrapState: const FirebaseBootstrapState(
          isAvailable: true,
          isConfigured: true,
        ),
      );
      addTearDown(controller.dispose);

      await expectLater(controller.push(), throwsA(isA<StateError>()));
      expect(repo.pushCalls, 1);
      expect(controller.state.canRetryLastAction, isTrue);

      await controller.retryLastAction();

      expect(repo.pushCalls, 2);
      expect(controller.state.isBusy, isFalse);
    });

    test('starts live sync on sign in and stops on sign out', () async {
      final auth = _MutableAuthService();
      final repo = _TrackingSyncRepository();
      final controller = SyncController(
        authService: auth,
        syncRepository: repo,
        bootstrapState: const FirebaseBootstrapState(
          isAvailable: true,
          isConfigured: true,
        ),
      );
      addTearDown(() async {
        await auth.dispose();
        controller.dispose();
      });

      auth.emit(const AuthSession(userId: 'u1', isAuthenticated: true));
      await Future<void>.delayed(Duration.zero);

      expect(repo.startLiveSyncCalls, 1);

      auth.emit(const AuthSession(userId: null, isAuthenticated: false));
      await Future<void>.delayed(Duration.zero);

      expect(repo.stopLiveSyncCalls, greaterThanOrEqualTo(1));
    });

    test('app resume auto-pull is throttled', () async {
      final repo = _TrackingSyncRepository();
      final controller = SyncController(
        authService: _FakeAuthService(),
        syncRepository: repo,
        bootstrapState: const FirebaseBootstrapState(
          isAvailable: true,
          isConfigured: true,
        ),
      );
      addTearDown(controller.dispose);

      await controller.onAppResumed();
      await controller.onAppResumed();

      expect(repo.pullCalls, 1);
    });
  });
}

class _FakeAuthService implements AuthService {
  @override
  AuthAvailability get availability => AuthAvailability.enabled;

  @override
  AuthSession get currentSession =>
      const AuthSession(userId: 'u1', isAuthenticated: true);

  @override
  Future<void> signIn() async {}

  @override
  Future<void> signOut() async {}

  @override
  Stream<AuthSession> watchSession() =>
      Stream<AuthSession>.value(currentSession);
}

class _NeverCompletesSyncRepository implements SyncRepository {
  @override
  Future<SyncOperationResult> pull() => Completer<SyncOperationResult>().future;

  @override
  Future<SyncOperationResult> push() => Completer<SyncOperationResult>().future;

  @override
  Stream<SyncStatusSnapshot> watchStatus() =>
      Stream<SyncStatusSnapshot>.value(SyncStatusSnapshot.idle);

  @override
  Future<void> startLiveSync() async {}

  @override
  Future<void> stopLiveSync() async {}
}

class _FlakySyncRepository implements SyncRepository {
  int pushCalls = 0;

  @override
  Future<SyncOperationResult> pull() async => const SyncOperationResult(
    upserts: 0,
    deletes: 0,
    skippedConflicts: 0,
    didMutate: false,
  );

  @override
  Future<SyncOperationResult> push() async {
    pushCalls += 1;
    if (pushCalls == 1) {
      throw StateError('temporary failure');
    }
    return const SyncOperationResult(
      upserts: 1,
      deletes: 0,
      skippedConflicts: 0,
      didMutate: true,
    );
  }

  @override
  Stream<SyncStatusSnapshot> watchStatus() =>
      Stream<SyncStatusSnapshot>.value(SyncStatusSnapshot.idle);

  @override
  Future<void> startLiveSync() async {}

  @override
  Future<void> stopLiveSync() async {}
}

class _TrackingSyncRepository implements SyncRepository {
  int pushCalls = 0;
  int pullCalls = 0;
  int startLiveSyncCalls = 0;
  int stopLiveSyncCalls = 0;

  @override
  Future<SyncOperationResult> pull() async {
    pullCalls += 1;
    return const SyncOperationResult(
      upserts: 0,
      deletes: 0,
      skippedConflicts: 0,
      didMutate: false,
    );
  }

  @override
  Future<SyncOperationResult> push() async {
    pushCalls += 1;
    return const SyncOperationResult(
      upserts: 0,
      deletes: 0,
      skippedConflicts: 0,
      didMutate: false,
    );
  }

  @override
  Future<void> startLiveSync() async {
    startLiveSyncCalls += 1;
  }

  @override
  Future<void> stopLiveSync() async {
    stopLiveSyncCalls += 1;
  }

  @override
  Stream<SyncStatusSnapshot> watchStatus() =>
      Stream<SyncStatusSnapshot>.value(SyncStatusSnapshot.idle);
}

class _MutableAuthService implements AuthService {
  final _controller = StreamController<AuthSession>.broadcast();
  AuthSession _current = const AuthSession(
    userId: null,
    isAuthenticated: false,
  );

  @override
  AuthAvailability get availability => AuthAvailability.enabled;

  @override
  AuthSession get currentSession => _current;

  void emit(AuthSession session) {
    _current = session;
    _controller.add(session);
  }

  @override
  Future<void> signIn() async {}

  @override
  Future<void> signOut() async {}

  @override
  Stream<AuthSession> watchSession() => Stream<AuthSession>.multi((multi) {
    multi.add(_current);
    final sub = _controller.stream.listen(multi.add);
    multi.onCancel = sub.cancel;
  });

  Future<void> dispose() => _controller.close();
}
