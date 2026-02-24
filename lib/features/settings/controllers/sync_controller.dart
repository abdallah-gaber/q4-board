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
  });

  final FirebaseBootstrapState bootstrapState;
  final AuthSession session;
  final SyncStatusSnapshot syncStatus;
  final bool isBusy;

  factory SyncControllerState.initial(FirebaseBootstrapState bootstrapState) =>
      SyncControllerState(
        bootstrapState: bootstrapState,
        session: const AuthSession(userId: null, isAuthenticated: false),
        syncStatus: bootstrapState.isAvailable
            ? SyncStatusSnapshot.idle
            : SyncStatusSnapshot.unavailable,
        isBusy: false,
      );

  SyncControllerState copyWith({
    FirebaseBootstrapState? bootstrapState,
    AuthSession? session,
    SyncStatusSnapshot? syncStatus,
    bool? isBusy,
  }) {
    return SyncControllerState(
      bootstrapState: bootstrapState ?? this.bootstrapState,
      session: session ?? this.session,
      syncStatus: syncStatus ?? this.syncStatus,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}

class SyncController extends StateNotifier<SyncControllerState> {
  SyncController({
    required AuthService authService,
    required SyncRepository syncRepository,
    required FirebaseBootstrapState bootstrapState,
  }) : _authService = authService,
       _syncRepository = syncRepository,
       super(SyncControllerState.initial(bootstrapState)) {
    _authSub = _authService.watchSession().listen((session) {
      state = state.copyWith(session: session);
    });
    _syncSub = _syncRepository.watchStatus().listen((syncStatus) {
      state = state.copyWith(syncStatus: syncStatus);
    });
  }

  final AuthService _authService;
  final SyncRepository _syncRepository;
  late final StreamSubscription<AuthSession> _authSub;
  late final StreamSubscription<SyncStatusSnapshot> _syncSub;

  Future<void> signIn() => _runBusy(_authService.signIn);

  Future<void> signOut() => _runBusy(_authService.signOut);

  Future<SyncOperationResult> push() => _runBusy(_syncRepository.push);

  Future<SyncOperationResult> pull() => _runBusy(_syncRepository.pull);

  Future<T> _runBusy<T>(Future<T> Function() action) async {
    state = state.copyWith(isBusy: true);
    try {
      return await action();
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  @override
  void dispose() {
    _authSub.cancel();
    _syncSub.cancel();
    super.dispose();
  }
}
