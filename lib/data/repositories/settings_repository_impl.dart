import '../../domain/entities/app_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/hive_local_datasource.dart';
import '../hive/models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._dataSource);

  final HiveLocalDataSource _dataSource;

  @override
  Stream<AppSettingsEntity> watchSettings() {
    return Stream<AppSettingsEntity>.multi((multi) async {
      multi.add(_readSettings());
      await for (final _ in _dataSource.settingsBox.watch()) {
        multi.add(_readSettings());
      }
    });
  }

  @override
  Future<AppSettingsEntity> getSettings() async => _readSettings();

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {
    await _dataSource.settingsBox.put(
      HiveLocalDataSource.settingsKey,
      AppSettingsModel.fromEntity(settings),
    );
  }

  AppSettingsEntity _readSettings() {
    final model =
        _dataSource.settingsBox.get(HiveLocalDataSource.settingsKey) ??
        AppSettingsModel.defaults();
    return model.toEntity();
  }
}
