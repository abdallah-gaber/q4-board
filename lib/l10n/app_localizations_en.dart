// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Q4 Board';

  @override
  String get board => 'Board';

  @override
  String get settings => 'Settings';

  @override
  String get searchHint => 'Search notes';

  @override
  String get showDone => 'Show done';

  @override
  String get filterAll => 'All';

  @override
  String get filterHideDone => 'Hide done';

  @override
  String get doneFilterControl => 'Done items filter';

  @override
  String get addNote => 'Add note';

  @override
  String get editNote => 'Edit note';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get dueDate => 'Due date';

  @override
  String get noDueDate => 'No due date';

  @override
  String get markDone => 'Done';

  @override
  String get moveTo => 'Move to';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get defaultShowDone => 'Default show done';

  @override
  String get syncComingSoon => 'Sync (coming soon)';

  @override
  String get syncComingSoonDesc =>
      'Firebase auth + cloud sync will be added in Phase 2.';

  @override
  String get q1Title => 'Important & Urgent';

  @override
  String get q2Title => 'Important & Not Urgent';

  @override
  String get q3Title => 'Not Important & Urgent';

  @override
  String get q4Title => 'Not Important & Not Urgent';

  @override
  String get q1Label => 'DO FIRST';

  @override
  String get q2Label => 'SCHEDULE';

  @override
  String get q3Label => 'DELEGATE';

  @override
  String get q4Label => 'DON\'T DO';

  @override
  String get q1TabSemantics => 'Do first quadrant';

  @override
  String get q2TabSemantics => 'Schedule quadrant';

  @override
  String get q3TabSemantics => 'Delegate quadrant';

  @override
  String get q4TabSemantics => 'Don\'t do quadrant';

  @override
  String get emptyQuadrant => 'No notes yet';

  @override
  String get emptySearch => 'No results for your search';

  @override
  String get noteDeleted => 'Note deleted';

  @override
  String get noteMoved => 'Note moved';

  @override
  String get requiredTitle => 'Title is required';

  @override
  String get clearDueDate => 'Clear date';

  @override
  String get pickDate => 'Pick date';

  @override
  String get doneChip => 'Done';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String get loadDemoData => 'Load demo data';

  @override
  String get loadDemoDataDesc =>
      'Replace local notes with curated demo content for screenshots.';

  @override
  String demoDataLoaded(int count) {
    return '$count demo notes loaded';
  }

  @override
  String get resetLocalData => 'Reset local data';

  @override
  String get resetLocalDataDesc =>
      'Clear all notes and settings saved on this device.';

  @override
  String get resetLocalDataConfirmTitle => 'Reset local data?';

  @override
  String get resetLocalDataConfirmBody =>
      'This will permanently remove your notes and settings from this device.';

  @override
  String get resetAction => 'Reset';

  @override
  String get localDataResetSuccess => 'Local data has been reset';
}
