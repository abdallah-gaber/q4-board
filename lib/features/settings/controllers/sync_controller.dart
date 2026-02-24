import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/providers/app_providers.dart';
import '../../../domain/repositories/sync_repository.dart';
import '../../../domain/services/auth_service.dart';

final syncControllerProvider =
    StateNotifierProvider<SyncController, SyncControllerState>(
      (ref) => SyncController(
        authService: ref.watch(authServiceProvider),
        syncRepository: ref.watch(syncRepositoryProvider),
        bootstrapState: ref.watch(firebaseBootstrapStateProvider),
      ),
    );

class SyncControllerState {
  const SyncControllerState({
    required this.bootstrapState,
    required this.session,
    required this.syncStatus,
    required this.isBusy,
    required this.lastAction,
    this.lastError,
  });

  final FirebaseBootstrapState bootstrapState;
  final AuthSession session;
  final SyncStatusSnapshot syncStatus;
  final bool isBusy;
  final SyncActionType? lastAction;
  final SyncActionError? lastError;

  factory SyncControllerState.initial(FirebaseBootstrapState bootstrapState) =>
      SyncControllerState(
        bootstrapState: bootstrapState,
        session: const AuthSession(userId: null, isAuthenticated: false),
        syncStatus: bootstrapState.isAvailable
            ? SyncStatusSnapshot.idle
            : SyncStatusSnapshot.unavailable,
        isBusy: false,
        lastAction: null,
      );

  SyncControllerState copyWith({
    FirebaseBootstrapState? bootstrapState,
    AuthSession? session,
    SyncStatusSnapshot? syncStatus,
    bool? isBusy,
    SyncActionType? lastAction,
    bool clearLastAction = false,
    SyncActionError? lastError,
    bool clearLastError = false,
  }) {
    return SyncControllerState(
      bootstrapState: bootstrapState ?? this.bootstrapState,
      session: session ?? this.session,
      syncStatus: syncStatus ?? this.syncStatus,
      isBusy: isBusy ?? this.isBusy,
      lastAction: clearLastAction ? null : (lastAction ?? this.lastAction),
      lastError: clearLastError ? null : (lastError ?? this.lastError),
    );
  }

  bool get canRetryLastAction => !isBusy && (lastError?.isRetryable ?? false);
}

enum SyncActionType { signIn, signOut, push, pull }

class SyncActionError {
  const SyncActionError({
    required this.action,
    required this.rawError,
    required this.isTimeout,
    required this.isRetryable,
  });

  final SyncActionType action;
  final Object rawError;
  final bool isTimeout;
  final bool isRetryable;
}

class SyncController extends StateNotifier<SyncControllerState> {
  SyncController({
    required AuthService authService,
    required SyncRepository syncRepository,
    required FirebaseBootstrapState bootstrapState,
    Duration operationTimeout = const Duration(seconds: 20),
  }) : _authService = authService,
       _syncRepository = syncRepository,
       _operationTimeout = operationTimeout,
       super(SyncControllerState.initial(bootstrapState)) {
    _authSub = _authService.watchSession().listen((session) {
      state = state.copyWith(session: session);
      unawaited(_handleSessionChange(session));
    });
    _syncSub = _syncRepository.watchStatus().listen((syncStatus) {
      state = state.copyWith(syncStatus: syncStatus);
    });
  }

  final AuthService _authService;
  final SyncRepository _syncRepository;
  final Duration _operationTimeout;
  DateTime? _lastAutoPullAt;
  late final StreamSubscription<AuthSession> _authSub;
  late final StreamSubscription<SyncStatusSnapshot> _syncSub;

  Future<void> signIn() => _runBusy(SyncActionType.signIn, _authService.signIn);

  Future<void> signOut() =>
      _runBusy(SyncActionType.signOut, _authService.signOut);

  Future<SyncOperationResult> push() =>
      _runBusy(SyncActionType.push, _syncRepository.push);

  Future<SyncOperationResult> pull() =>
      _runBusy(SyncActionType.pull, _syncRepository.pull);

  Future<void> retryLastAction() async {
    switch (state.lastAction) {
      case SyncActionType.signIn:
        return signIn();
      case SyncActionType.signOut:
        return signOut();
      case SyncActionType.push:
        await push();
        return;
      case SyncActionType.pull:
        await pull();
        return;
      case null:
        return;
    }
  }

  Future<void> onAppResumed() async {
    if (!state.bootstrapState.isAvailable ||
        !state.session.isAuthenticated ||
        state.isBusy) {
      return;
    }
    final now = DateTime.now();
    if (_lastAutoPullAt != null &&
        now.difference(_lastAutoPullAt!) < const Duration(seconds: 20)) {
      return;
    }
    _lastAutoPullAt = now;
    try {
      await _runBusy(SyncActionType.pull, _syncRepository.pull);
    } catch (_) {
      // App-resume auto sync failures are surfaced in controller status/UI.
    }
  }

  Future<R> _runBusy<R>(
    SyncActionType actionType,
    Future<R> Function() action,
  ) async {
    state = state.copyWith(
      isBusy: true,
      lastAction: actionType,
      clearLastError: true,
    );
    try {
      return await action().timeout(_operationTimeout);
    } on TimeoutException catch (error) {
      state = state.copyWith(
        lastError: SyncActionError(
          action: actionType,
          rawError: error,
          isTimeout: true,
          isRetryable: true,
        ),
      );
      rethrow;
    } catch (error) {
      state = state.copyWith(
        lastError: SyncActionError(
          action: actionType,
          rawError: error,
          isTimeout: false,
          isRetryable: actionType != SyncActionType.signOut,
        ),
      );
      rethrow;
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> _handleSessionChange(AuthSession session) async {
    if (!state.bootstrapState.isAvailable) {
      return;
    }
    if (!session.isAuthenticated) {
      await _syncRepository.stopLiveSync();
      _lastAutoPullAt = null;
      return;
    }
    try {
      await _syncRepository.startLiveSync();
      await onAppResumed();
    } catch (error) {
      state = state.copyWith(
        lastError: SyncActionError(
          action: SyncActionType.pull,
          rawError: error,
          isTimeout: false,
          isRetryable: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_syncRepository.stopLiveSync());
    _authSub.cancel();
    _syncSub.cancel();
    super.dispose();
  }
}
