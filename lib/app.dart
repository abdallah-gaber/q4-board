import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q4_board/l10n/app_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/enums/app_language_mode.dart';
import 'domain/enums/theme_preference.dart';
import 'features/settings/controllers/settings_controller.dart';
import 'features/settings/controllers/sync_controller.dart';

class Q4BoardApp extends ConsumerStatefulWidget {
  const Q4BoardApp({super.key});

  @override
  ConsumerState<Q4BoardApp> createState() => _Q4BoardAppState();
}

class _Q4BoardAppState extends ConsumerState<Q4BoardApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(syncControllerProvider.notifier).onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsControllerProvider);
    ref.watch(syncControllerProvider);

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
