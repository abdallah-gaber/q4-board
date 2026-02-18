import '../../../domain/entities/app_settings_entity.dart';
import '../../../domain/enums/app_language_mode.dart';
import '../../../domain/enums/theme_preference.dart';

class AppSettingsModel {
  const AppSettingsModel({
    required this.themePreference,
    required this.languageMode,
    required this.defaultShowDone,
  });

  final ThemePreference themePreference;
  final AppLanguageMode languageMode;
  final bool defaultShowDone;

  factory AppSettingsModel.defaults() => const AppSettingsModel(
    themePreference: ThemePreference.system,
    languageMode: AppLanguageMode.system,
    defaultShowDone: true,
  );

  factory AppSettingsModel.fromEntity(AppSettingsEntity entity) =>
      AppSettingsModel(
        themePreference: entity.themePreference,
        languageMode: entity.languageMode,
        defaultShowDone: entity.defaultShowDone,
      );

  AppSettingsEntity toEntity() => AppSettingsEntity(
    themePreference: themePreference,
    languageMode: languageMode,
    defaultShowDone: defaultShowDone,
  );
}
