import 'package:hive/hive.dart';

import '../../hive/hive_initializer.dart';
import '../../hive/models/app_settings_model.dart';
import '../../hive/models/note_model.dart';

class HiveLocalDataSource {
  const HiveLocalDataSource();

  static const String settingsKey = 'app_settings';

  Box<NoteModel> get notesBox =>
      Hive.box<NoteModel>(HiveInitializer.notesBoxName);

  Box<AppSettingsModel> get settingsBox =>
      Hive.box<AppSettingsModel>(HiveInitializer.settingsBoxName);
}
