import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../domain/entities/app_settings_entity.dart';
import '../../../domain/enums/app_language_mode.dart';
import '../../../domain/enums/theme_preference.dart';
import '../../../domain/repositories/settings_repository.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettingsEntity>(
      (ref) => SettingsController(ref.watch(settingsRepositoryProvider)),
    );

class SettingsController extends StateNotifier<AppSettingsEntity> {
  SettingsController(this._settingsRepository)
    : super(AppSettingsEntity.defaults()) {
    _subscription = _settingsRepository.watchSettings().listen((settings) {
      state = settings;
    });
  }

  final SettingsRepository _settingsRepository;
  late final StreamSubscription<AppSettingsEntity> _subscription;

  Future<void> setThemePreference(ThemePreference preference) async {
    await _settingsRepository.saveSettings(
      state.copyWith(themePreference: preference),
    );
  }

  Future<void> setLanguageMode(AppLanguageMode languageMode) async {
    await _settingsRepository.saveSettings(
      state.copyWith(languageMode: languageMode),
    );
  }

  Future<void> setDefaultShowDone(bool value) async {
    await _settingsRepository.saveSettings(
      state.copyWith(defaultShowDone: value),
    );
  }

  Future<void> setCloudSyncEnabled(bool value) async {
    await _settingsRepository.saveSettings(
      state.copyWith(cloudSyncEnabled: value),
    );
  }

  Future<void> setLiveSyncEnabled(bool value) async {
    await _settingsRepository.saveSettings(
      state.copyWith(liveSyncEnabled: value),
    );
  }

  Future<void> setAutoSyncOnResumeEnabled(bool value) async {
    await _settingsRepository.saveSettings(
      state.copyWith(autoSyncOnResumeEnabled: value),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
