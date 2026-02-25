import '../../../domain/entities/app_settings_entity.dart';
import '../../../domain/enums/app_language_mode.dart';
import '../../../domain/enums/theme_preference.dart';

class AppSettingsModel {
  const AppSettingsModel({
    required this.themePreference,
    required this.languageMode,
    required this.defaultShowDone,
    required this.cloudSyncEnabled,
    required this.liveSyncEnabled,
    required this.autoSyncOnResumeEnabled,
    this.lastSyncAt,
    this.lastSyncStatusKey,
  });

  final ThemePreference themePreference;
  final AppLanguageMode languageMode;
  final bool defaultShowDone;
  final bool cloudSyncEnabled;
  final bool liveSyncEnabled;
  final bool autoSyncOnResumeEnabled;
  final DateTime? lastSyncAt;
  final String? lastSyncStatusKey;

  factory AppSettingsModel.defaults() => const AppSettingsModel(
    themePreference: ThemePreference.system,
    languageMode: AppLanguageMode.system,
    defaultShowDone: true,
    cloudSyncEnabled: true,
    liveSyncEnabled: true,
    autoSyncOnResumeEnabled: true,
  );

  factory AppSettingsModel.fromEntity(AppSettingsEntity entity) =>
      AppSettingsModel(
        themePreference: entity.themePreference,
        languageMode: entity.languageMode,
        defaultShowDone: entity.defaultShowDone,
        cloudSyncEnabled: entity.cloudSyncEnabled,
        liveSyncEnabled: entity.liveSyncEnabled,
        autoSyncOnResumeEnabled: entity.autoSyncOnResumeEnabled,
        lastSyncAt: entity.lastSyncAt,
        lastSyncStatusKey: entity.lastSyncStatusKey,
      );

  AppSettingsEntity toEntity() => AppSettingsEntity(
    themePreference: themePreference,
    languageMode: languageMode,
    defaultShowDone: defaultShowDone,
    cloudSyncEnabled: cloudSyncEnabled,
    liveSyncEnabled: liveSyncEnabled,
    autoSyncOnResumeEnabled: autoSyncOnResumeEnabled,
    lastSyncAt: lastSyncAt,
    lastSyncStatusKey: lastSyncStatusKey,
  );
}
