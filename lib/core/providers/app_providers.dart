import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/hive_local_datasource.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/services/local_data_maintenance_service.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/settings_repository.dart';

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
