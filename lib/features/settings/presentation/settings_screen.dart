import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q4_board/l10n/app_localizations.dart';

import '../../../core/design/app_radii.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/providers/app_providers.dart';
import '../../../domain/enums/app_language_mode.dart';
import '../../../domain/enums/theme_preference.dart';
import '../../../domain/repositories/sync_repository.dart';
import '../controllers/settings_controller.dart';
import '../controllers/sync_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(settingsControllerProvider.notifier);
    final settings = ref.watch(settingsControllerProvider);
    final syncState = ref.watch(syncControllerProvider);
    final syncController = ref.read(syncControllerProvider.notifier);

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
          _SectionCard(
            title: l10n.syncSectionTitle,
            child: _SyncSection(
              state: syncState,
              onSignIn: () => _onSyncSignIn(context, syncController),
              onSignOut: () => _onSyncSignOut(context, syncController),
              onPush: () => _onSyncPush(context, syncController),
              onPull: () => _onSyncPull(context, syncController),
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

  Future<void> _onSyncSignIn(
    BuildContext context,
    SyncController controller,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await controller.signIn();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.syncSignedIn)));
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.syncErrorGeneric)));
    }
  }

  Future<void> _onSyncSignOut(
    BuildContext context,
    SyncController controller,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await controller.signOut();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.syncSignedOut)));
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.syncErrorGeneric)));
    }
  }

  Future<void> _onSyncPush(
    BuildContext context,
    SyncController controller,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await controller.push();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              l10n.syncPushDone(
                result.upserts,
                result.deletes,
                result.skippedConflicts,
              ),
            ),
          ),
        );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.syncErrorGeneric)));
    }
  }

  Future<void> _onSyncPull(
    BuildContext context,
    SyncController controller,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await controller.pull();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              l10n.syncPullDone(
                result.upserts,
                result.deletes,
                result.skippedConflicts,
              ),
            ),
          ),
        );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.syncErrorGeneric)));
    }
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

class _SyncSection extends StatelessWidget {
  const _SyncSection({
    required this.state,
    required this.onSignIn,
    required this.onSignOut,
    required this.onPush,
    required this.onPull,
  });

  final SyncControllerState state;
  final VoidCallback onSignIn;
  final VoidCallback onSignOut;
  final VoidCallback onPush;
  final VoidCallback onPull;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canUseCloud = state.bootstrapState.isAvailable;
    final isSignedIn = state.session.isAuthenticated;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              canUseCloud
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_off_outlined,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                canUseCloud
                    ? (isSignedIn ? l10n.syncConnected : l10n.syncNotSignedIn)
                    : l10n.syncUnavailable,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        if (state.session.userId != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.syncUserId(state.session.userId!),
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (!canUseCloud) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.syncNotConfiguredHelp,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FilledButton.tonalIcon(
              onPressed: (!canUseCloud || state.isBusy || isSignedIn)
                  ? null
                  : onSignIn,
              icon: const Icon(Icons.login_outlined),
              label: Text(l10n.syncSignIn),
            ),
            FilledButton.tonalIcon(
              onPressed: (!canUseCloud || state.isBusy || !isSignedIn)
                  ? null
                  : onSignOut,
              icon: const Icon(Icons.logout_outlined),
              label: Text(l10n.syncSignOut),
            ),
            FilledButton.tonalIcon(
              onPressed: (!canUseCloud || state.isBusy || !isSignedIn)
                  ? null
                  : onPush,
              icon: const Icon(Icons.cloud_upload_outlined),
              label: Text(l10n.syncPush),
            ),
            FilledButton.tonalIcon(
              onPressed: (!canUseCloud || state.isBusy || !isSignedIn)
                  ? null
                  : onPull,
              icon: const Icon(Icons.cloud_download_outlined),
              label: Text(l10n.syncPull),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            if (state.isBusy) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                _syncStatusText(context, state.syncStatus),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _syncStatusText(BuildContext context, SyncStatusSnapshot status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status.code) {
      case SyncStatusCode.unavailable:
        return l10n.syncStatusUnavailable;
      case SyncStatusCode.idle:
        return l10n.syncStatusIdle;
      case SyncStatusCode.authRequired:
        return l10n.syncStatusAuthRequired;
      case SyncStatusCode.pushing:
        return l10n.syncStatusPushing;
      case SyncStatusCode.pulling:
        return l10n.syncStatusPulling;
      case SyncStatusCode.success:
        return _syncSuccessText(l10n, status);
      case SyncStatusCode.error:
        return l10n.syncStatusError;
    }
  }

  String _syncSuccessText(AppLocalizations l10n, SyncStatusSnapshot status) {
    final key = status.lastMessage;
    if (key == 'push_conflicts_skipped') {
      return l10n.syncStatusPushCompleteConflicts;
    }
    if (key == 'pull_conflicts_skipped') {
      return l10n.syncStatusPullCompleteConflicts;
    }
    if (key == 'pull_remote_empty_local_kept') {
      return l10n.syncStatusPullRemoteEmptyLocalKept;
    }
    if (key == 'push_complete') {
      return l10n.syncStatusPushComplete;
    }
    if (key == 'pull_complete') {
      return l10n.syncStatusPullComplete;
    }
    return l10n.syncStatusSuccess;
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
