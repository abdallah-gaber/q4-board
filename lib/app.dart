import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q4_board/l10n/app_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/enums/app_language_mode.dart';
import 'domain/enums/theme_preference.dart';
import 'features/settings/controllers/settings_controller.dart';

class Q4BoardApp extends ConsumerWidget {
  const Q4BoardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      title: 'Q4 Board',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themePreference.toThemeMode(),
      locale: settings.languageMode.localeOrNull,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
