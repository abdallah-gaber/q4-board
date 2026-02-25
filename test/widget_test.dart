import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q4_board/app.dart';
import 'package:q4_board/core/providers/app_providers.dart';
import 'package:q4_board/domain/entities/app_settings_entity.dart';
import 'package:q4_board/domain/enums/app_language_mode.dart';
import 'package:q4_board/domain/enums/theme_preference.dart';
import 'package:q4_board/features/board/presentation/widgets/quadrant_panel.dart';

import 'helpers/in_memory_repositories.dart';

void main() {
  testWidgets('board renders 4 quadrants and can add a note', (tester) async {
    final noteRepository = InMemoryNoteRepository();
    final settingsRepository = InMemorySettingsRepository(
      initial: const AppSettingsEntity(
        themePreference: ThemePreference.light,
        languageMode: AppLanguageMode.english,
        defaultShowDone: true,
        cloudSyncEnabled: true,
        liveSyncEnabled: true,
        autoSyncOnResumeEnabled: true,
      ),
    );

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 1000);

    addTearDown(() async {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await noteRepository.dispose();
      await settingsRepository.dispose();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          noteRepositoryProvider.overrideWithValue(noteRepository),
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
        ],
        child: const Q4BoardApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(QuadrantPanel), findsNWidgets(4));

    await tester.tap(find.byTooltip('Add note').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Test note');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Test note'), findsOneWidget);
  });
}
