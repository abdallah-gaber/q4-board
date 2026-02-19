import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q4_board/l10n/app_localizations.dart';

import '../../../core/design/app_radii.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/providers/app_providers.dart';
import '../../../domain/enums/app_language_mode.dart';
import '../../../domain/enums/theme_preference.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(settingsControllerProvider.notifier);
    final settings = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SectionCard(
            title: l10n.themeMode,
            child: SegmentedButton<ThemePreference>(
              segments: [
                ButtonSegment(
                  value: ThemePreference.system,
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemePreference.light,
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemePreference.dark,
                  label: Text(l10n.themeDark),
                ),
              ],
              selected: {settings.themePreference},
              onSelectionChanged: (selection) {
                controller.setThemePreference(selection.first);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: l10n.language,
            child: SegmentedButton<AppLanguageMode>(
              segments: [
                ButtonSegment(
                  value: AppLanguageMode.system,
                  label: Text(l10n.languageSystem),
                ),
                ButtonSegment(
                  value: AppLanguageMode.english,
                  label: Text(l10n.languageEnglish),
                ),
                ButtonSegment(
                  value: AppLanguageMode.arabic,
                  label: Text(l10n.languageArabic),
                ),
              ],
              selected: {settings.languageMode},
              onSelectionChanged: (selection) {
                controller.setLanguageMode(selection.first);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: l10n.board,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: settings.defaultShowDone,
              title: Text(l10n.defaultShowDone),
              onChanged: controller.setDefaultShowDone,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: ListTile(
              leading: const Icon(Icons.cloud_off_outlined),
              title: Text(l10n.syncComingSoon),
              subtitle: Text(l10n.syncComingSoonDesc),
              enabled: false,
            ),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: AppSpacing.md),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: ListTile(
                leading: const Icon(Icons.science_outlined),
                title: Text(l10n.loadDemoData),
                subtitle: Text(l10n.loadDemoDataDesc),
                trailing: FilledButton.tonal(
                  onPressed: () => _onLoadDemoDataPressed(context, ref),
                  child: Text(l10n.loadDemoData),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_outlined),
              title: Text(l10n.resetLocalData),
              subtitle: Text(l10n.resetLocalDataDesc),
              trailing: FilledButton.tonal(
                onPressed: () => _onResetDataPressed(context, ref),
                child: Text(l10n.resetAction),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onResetDataPressed(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.resetLocalDataConfirmTitle),
          content: Text(l10n.resetLocalDataConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.resetAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await ref.read(localDataMaintenanceServiceProvider).resetAllLocalData();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.localDataResetSuccess)));
  }

  Future<void> _onLoadDemoDataPressed(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final count = await ref
        .read(localDataMaintenanceServiceProvider)
        .loadDemoData();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.demoDataLoaded(count))));
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}
