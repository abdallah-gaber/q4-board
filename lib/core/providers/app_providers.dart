import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/hive_local_datasource.dart';
import '../../data/repositories/firestore_sync_repository_impl.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/services/firebase_auth_service_impl.dart';
import '../../data/services/local_data_maintenance_service.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/auth_service.dart';
import '../firebase/firebase_bootstrap.dart';

final firebaseBootstrapStateProvider = Provider<FirebaseBootstrapState>(
  (ref) => FirebaseBootstrapState.notConfigured,
);

final localDataSourceProvider = Provider<HiveLocalDataSource>(
  (ref) => const HiveLocalDataSource(),
);

final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepositoryImpl(ref.watch(localDataSourceProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.watch(localDataSourceProvider)),
);

final localDataMaintenanceServiceProvider =
    Provider<LocalDataMaintenanceService>(
      (ref) => const LocalDataMaintenanceService(),
    );

final _firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  final bootstrap = ref.watch(firebaseBootstrapStateProvider);
  if (!bootstrap.isAvailable) {
    return null;
  }
  return FirebaseAuth.instance;
});

final _firebaseFirestoreProvider = Provider<FirebaseFirestore?>((ref) {
  final bootstrap = ref.watch(firebaseBootstrapStateProvider);
  if (!bootstrap.isAvailable) {
    return null;
  }
  return FirebaseFirestore.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  final auth = ref.watch(_firebaseAuthProvider);
  if (auth == null) {
    return const UnavailableAuthService();
  }
  return FirebaseAuthServiceImpl(auth);
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final firestore = ref.watch(_firebaseFirestoreProvider);
  final auth = ref.watch(_firebaseAuthProvider);
  if (firestore == null || auth == null) {
    return const UnavailableSyncRepository();
  }
  return FirestoreSyncRepositoryImpl(
    firestore: firestore,
    auth: auth,
    localNoteRepository: ref.watch(noteRepositoryProvider),
  );
});
