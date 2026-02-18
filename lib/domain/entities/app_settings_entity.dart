import '../enums/app_language_mode.dart';
import '../enums/theme_preference.dart';

class AppSettingsEntity {
  const AppSettingsEntity({
    required this.themePreference,
    required this.languageMode,
    required this.defaultShowDone,
  });

  final ThemePreference themePreference;
  final AppLanguageMode languageMode;
  final bool defaultShowDone;

  factory AppSettingsEntity.defaults() => const AppSettingsEntity(
    themePreference: ThemePreference.system,
    languageMode: AppLanguageMode.system,
    defaultShowDone: true,
  );

  AppSettingsEntity copyWith({
    ThemePreference? themePreference,
    AppLanguageMode? languageMode,
    bool? defaultShowDone,
  }) {
    return AppSettingsEntity(
      themePreference: themePreference ?? this.themePreference,
      languageMode: languageMode ?? this.languageMode,
      defaultShowDone: defaultShowDone ?? this.defaultShowDone,
    );
  }
}
