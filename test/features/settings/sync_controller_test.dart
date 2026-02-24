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
}
