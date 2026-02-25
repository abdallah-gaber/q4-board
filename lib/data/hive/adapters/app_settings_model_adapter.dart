import 'package:hive/hive.dart';

import '../../../domain/enums/app_language_mode.dart';
import '../../../domain/enums/theme_preference.dart';
import '../hive_type_ids.dart';
import '../models/app_settings_model.dart';

class AppSettingsModelAdapter extends TypeAdapter<AppSettingsModel> {
  @override
  final int typeId = HiveTypeIds.appSettingsModel;

  @override
  AppSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final rawThemeIndex = fields[0];
    final rawLanguageIndex = fields[1];
    final rawShowDone = fields[2];
    final rawCloudSyncEnabled = fields[3];
    final rawLiveSyncEnabled = fields[4];
    final rawAutoSyncOnResumeEnabled = fields[5];
    final rawLastSyncAt = fields[6];
    final rawLastSyncStatusKey = fields[7];
    final rawAutoPushLocalChangesEnabled = fields[8];

    final themePreference =
        rawThemeIndex is int &&
            rawThemeIndex >= 0 &&
            rawThemeIndex < ThemePreference.values.length
        ? ThemePreference.values[rawThemeIndex]
        : ThemePreference.system;
    final languageMode =
        rawLanguageIndex is int &&
            rawLanguageIndex >= 0 &&
            rawLanguageIndex < AppLanguageMode.values.length
        ? AppLanguageMode.values[rawLanguageIndex]
        : AppLanguageMode.system;
    final defaultShowDone = rawShowDone is bool ? rawShowDone : true;
    final cloudSyncEnabled = rawCloudSyncEnabled is bool
        ? rawCloudSyncEnabled
        : true;
    final liveSyncEnabled = rawLiveSyncEnabled is bool
        ? rawLiveSyncEnabled
        : true;
    final autoSyncOnResumeEnabled = rawAutoSyncOnResumeEnabled is bool
        ? rawAutoSyncOnResumeEnabled
        : true;
    final autoPushLocalChangesEnabled = rawAutoPushLocalChangesEnabled is bool
        ? rawAutoPushLocalChangesEnabled
        : false;
    final lastSyncAt = rawLastSyncAt is DateTime ? rawLastSyncAt : null;
    final lastSyncStatusKey =
        rawLastSyncStatusKey is String && rawLastSyncStatusKey.isNotEmpty
        ? rawLastSyncStatusKey
        : null;

    return AppSettingsModel(
      themePreference: themePreference,
      languageMode: languageMode,
      defaultShowDone: defaultShowDone,
      cloudSyncEnabled: cloudSyncEnabled,
      liveSyncEnabled: liveSyncEnabled,
      autoSyncOnResumeEnabled: autoSyncOnResumeEnabled,
      autoPushLocalChangesEnabled: autoPushLocalChangesEnabled,
      lastSyncAt: lastSyncAt,
      lastSyncStatusKey: lastSyncStatusKey,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.themePreference.index)
      ..writeByte(1)
      ..write(obj.languageMode.index)
      ..writeByte(2)
      ..write(obj.defaultShowDone)
      ..writeByte(3)
      ..write(obj.cloudSyncEnabled)
      ..writeByte(4)
      ..write(obj.liveSyncEnabled)
      ..writeByte(5)
      ..write(obj.autoSyncOnResumeEnabled)
      ..writeByte(6)
      ..write(obj.lastSyncAt)
      ..writeByte(7)
      ..write(obj.lastSyncStatusKey)
      ..writeByte(8)
      ..write(obj.autoPushLocalChangesEnabled);
  }
}
