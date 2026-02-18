import 'package:flutter/material.dart';

enum AppLanguageMode { system, english, arabic }

extension AppLanguageModeX on AppLanguageMode {
  Locale? get localeOrNull {
    switch (this) {
      case AppLanguageMode.system:
        return null;
      case AppLanguageMode.english:
        return const Locale('en');
      case AppLanguageMode.arabic:
        return const Locale('ar');
    }
  }
}
