import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Q4 Board'**
  String get appTitle;

  /// No description provided for @board.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get board;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes'**
  String get searchHint;

  /// No description provided for @showDone.
  ///
  /// In en, this message translates to:
  /// **'Show done'**
  String get showDone;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterHideDone.
  ///
  /// In en, this message translates to:
  /// **'Hide done'**
  String get filterHideDone;

  /// No description provided for @doneFilterControl.
  ///
  /// In en, this message translates to:
  /// **'Done items filter'**
  String get doneFilterControl;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @noDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get noDueDate;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get markDone;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get moveTo;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @defaultShowDone.
  ///
  /// In en, this message translates to:
  /// **'Default show done'**
  String get defaultShowDone;

  /// No description provided for @syncComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Sync (coming soon)'**
  String get syncComingSoon;

  /// No description provided for @syncComingSoonDesc.
  ///
  /// In en, this message translates to:
  /// **'Firebase auth + cloud sync will be added in Phase 2.'**
  String get syncComingSoonDesc;

  /// No description provided for @q1Title.
  ///
  /// In en, this message translates to:
  /// **'Important & Urgent'**
  String get q1Title;

  /// No description provided for @q2Title.
  ///
  /// In en, this message translates to:
  /// **'Important & Not Urgent'**
  String get q2Title;

  /// No description provided for @q3Title.
  ///
  /// In en, this message translates to:
  /// **'Not Important & Urgent'**
  String get q3Title;

  /// No description provided for @q4Title.
  ///
  /// In en, this message translates to:
  /// **'Not Important & Not Urgent'**
  String get q4Title;

  /// No description provided for @q1Label.
  ///
  /// In en, this message translates to:
  /// **'DO FIRST'**
  String get q1Label;

  /// No description provided for @q2Label.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULE'**
  String get q2Label;

  /// No description provided for @q3Label.
  ///
  /// In en, this message translates to:
  /// **'DELEGATE'**
  String get q3Label;

  /// No description provided for @q4Label.
  ///
  /// In en, this message translates to:
  /// **'DON\'T DO'**
  String get q4Label;

  /// No description provided for @q1TabSemantics.
  ///
  /// In en, this message translates to:
  /// **'Do first quadrant'**
  String get q1TabSemantics;

  /// No description provided for @q2TabSemantics.
  ///
  /// In en, this message translates to:
  /// **'Schedule quadrant'**
  String get q2TabSemantics;

  /// No description provided for @q3TabSemantics.
  ///
  /// In en, this message translates to:
  /// **'Delegate quadrant'**
  String get q3TabSemantics;

  /// No description provided for @q4TabSemantics.
  ///
  /// In en, this message translates to:
  /// **'Don\'t do quadrant'**
  String get q4TabSemantics;

  /// No description provided for @emptyQuadrant.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get emptyQuadrant;

  /// No description provided for @emptySearch.
  ///
  /// In en, this message translates to:
  /// **'No results for your search'**
  String get emptySearch;

  /// No description provided for @noteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note deleted'**
  String get noteDeleted;

  /// No description provided for @noteMoved.
  ///
  /// In en, this message translates to:
  /// **'Note moved'**
  String get noteMoved;

  /// No description provided for @requiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get requiredTitle;

  /// No description provided for @clearDueDate.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get clearDueDate;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get pickDate;

  /// No description provided for @doneChip.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneChip;

  /// No description provided for @dragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get dragToReorder;

  /// No description provided for @loadDemoData.
  ///
  /// In en, this message translates to:
  /// **'Load demo data'**
  String get loadDemoData;

  /// No description provided for @loadDemoDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Replace local notes with curated demo content for screenshots.'**
  String get loadDemoDataDesc;

  /// No description provided for @demoDataLoaded.
  ///
  /// In en, this message translates to:
  /// **'{count} demo notes loaded'**
  String demoDataLoaded(int count);

  /// No description provided for @resetLocalData.
  ///
  /// In en, this message translates to:
  /// **'Reset local data'**
  String get resetLocalData;

  /// No description provided for @resetLocalDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear all notes and settings saved on this device.'**
  String get resetLocalDataDesc;

  /// No description provided for @resetLocalDataConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset local data?'**
  String get resetLocalDataConfirmTitle;

  /// No description provided for @resetLocalDataConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove your notes and settings from this device.'**
  String get resetLocalDataConfirmBody;

  /// No description provided for @resetAction.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetAction;

  /// No description provided for @localDataResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Local data has been reset'**
  String get localDataResetSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
