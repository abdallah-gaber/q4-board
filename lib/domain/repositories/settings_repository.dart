import '../entities/app_settings_entity.dart';

abstract interface class SettingsRepository {
  Stream<AppSettingsEntity> watchSettings();

  Future<AppSettingsEntity> getSettings();

  Future<void> saveSettings(AppSettingsEntity settings);
}
