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

    return AppSettingsModel(
      themePreference: themePreference,
      languageMode: languageMode,
      defaultShowDone: defaultShowDone,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.themePreference.index)
      ..writeByte(1)
      ..write(obj.languageMode.index)
      ..writeByte(2)
      ..write(obj.defaultShowDone);
  }
}
