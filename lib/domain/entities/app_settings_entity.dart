import '../enums/app_language_mode.dart';
import '../enums/theme_preference.dart';

class AppSettingsEntity {
  const AppSettingsEntity({
    required this.themePreference,
    required this.languageMode,
    required this.defaultShowDone,
    required this.cloudSyncEnabled,
    required this.liveSyncEnabled,
    required this.autoSyncOnResumeEnabled,
    this.autoPushLocalChangesEnabled = false,
    this.lastSyncAt,
    this.lastSyncStatusKey,
  });

  final ThemePreference themePreference;
  final AppLanguageMode languageMode;
  final bool defaultShowDone;
  final bool cloudSyncEnabled;
  final bool liveSyncEnabled;
  final bool autoSyncOnResumeEnabled;
  final bool autoPushLocalChangesEnabled;
  final DateTime? lastSyncAt;
  final String? lastSyncStatusKey;

  factory AppSettingsEntity.defaults() => const AppSettingsEntity(
    themePreference: ThemePreference.system,
    languageMode: AppLanguageMode.system,
    defaultShowDone: true,
    cloudSyncEnabled: true,
    liveSyncEnabled: true,
    autoSyncOnResumeEnabled: true,
    autoPushLocalChangesEnabled: false,
  );

  AppSettingsEntity copyWith({
    ThemePreference? themePreference,
    AppLanguageMode? languageMode,
    bool? defaultShowDone,
    bool? cloudSyncEnabled,
    bool? liveSyncEnabled,
    bool? autoSyncOnResumeEnabled,
    bool? autoPushLocalChangesEnabled,
    DateTime? lastSyncAt,
    bool clearLastSyncAt = false,
    String? lastSyncStatusKey,
    bool clearLastSyncStatusKey = false,
  }) {
    return AppSettingsEntity(
      themePreference: themePreference ?? this.themePreference,
      languageMode: languageMode ?? this.languageMode,
      defaultShowDone: defaultShowDone ?? this.defaultShowDone,
      cloudSyncEnabled: cloudSyncEnabled ?? this.cloudSyncEnabled,
      liveSyncEnabled: liveSyncEnabled ?? this.liveSyncEnabled,
      autoSyncOnResumeEnabled:
          autoSyncOnResumeEnabled ?? this.autoSyncOnResumeEnabled,
      autoPushLocalChangesEnabled:
          autoPushLocalChangesEnabled ?? this.autoPushLocalChangesEnabled,
      lastSyncAt: clearLastSyncAt ? null : (lastSyncAt ?? this.lastSyncAt),
      lastSyncStatusKey: clearLastSyncStatusKey
          ? null
          : (lastSyncStatusKey ?? this.lastSyncStatusKey),
    );
  }
}
