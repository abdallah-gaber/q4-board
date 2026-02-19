import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:q4_board/l10n/app_localizations.dart';

import '../../../../core/design/app_radii.dart';
import '../../../../core/design/app_shadows.dart';
import '../../../../core/design/app_spacing.dart';
import '../../../../domain/entities/note_entity.dart';
import '../../../../domain/enums/quadrant_type.dart';
import '../quadrant_ui.dart';

class StickyNoteCard extends StatelessWidget {
  const StickyNoteCard({
    super.key,
    required this.note,
    required this.visual,
    required this.onToggleDone,
    required this.onEdit,
    required this.onDelete,
    this.onMove,
    this.trailing,
    this.disableActions = false,
    this.moveAsBottomSheet = false,
  });

  final NoteEntity note;
  final QuadrantVisual visual;
  final ValueChanged<bool> onToggleDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<QuadrantType>? onMove;
  final Widget? trailing;
  final bool disableActions;
  final bool moveAsBottomSheet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    final baseColor = visual.cardTint(theme.brightness);
    final cardColor = note.isDone
        ? Color.alphaBlend(
            theme.colorScheme.surface.withValues(alpha: 0.62),
            baseColor,
          )
        : baseColor;

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      decoration: note.isDone ? TextDecoration.lineThrough : null,
      color: note.isDone
          ? theme.colorScheme.onSurface.withValues(alpha: 0.68)
          : theme.colorScheme.onSurface,
    );

    final descriptionStyle = theme.textTheme.bodySmall?.copyWith(
      decoration: note.isDone ? TextDecoration.lineThrough : null,
      color: theme.colorScheme.onSurface.withValues(
        alpha: note.isDone ? 0.56 : 0.74,
      ),
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: note.isDone ? 0.9 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          boxShadow: AppShadows.soft(Colors.black),
          border: Border.all(
            color: visual.accentColor.withValues(
              alpha: note.isDone ? 0.11 : 0.18,
            ),
          ),
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadii.sm),
                  ),
                  color: visual.accentColor.withValues(alpha: 0.7),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(note.title, style: titleStyle)),
                      const SizedBox(width: AppSpacing.xs),
                      Checkbox(
                        value: note.isDone,
                        visualDensity: VisualDensity.compact,
                        onChanged: disableActions
                            ? null
                            : (value) => onToggleDone(value ?? false),
                      ),
                    ],
                  ),
                  if ((note.description ?? '').trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        note.description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: descriptionStyle,
                      ),
                    ),
                  if (note.dueAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            DateFormat.yMMMd(locale).format(note.dueAt!),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  if (note.isDone)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Chip(
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                        label: Text(
                          l10n.doneChip,
                          style: theme.textTheme.labelSmall,
                        ),
                        avatar: const Icon(Icons.check_rounded, size: 14),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      if (onMove != null && moveAsBottomSheet)
                        _ActionIconButton(
                          icon: Icons.swap_horiz_rounded,
                          tooltip: l10n.moveTo,
                          onPressed: disableActions
                              ? null
                              : () => _handleMove(context, l10n),
                        ),
                      if (onMove != null && !moveAsBottomSheet)
                        PopupMenuButton<QuadrantType>(
                          enabled: !disableActions,
                          tooltip: l10n.moveTo,
                          icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                          onSelected: onMove,
                          itemBuilder: (context) => QuadrantType.values
                              .where((q) => q != note.quadrantType)
                              .map(
                                (q) => PopupMenuItem<QuadrantType>(
                                  value: q,
                                  child: Text(quadrantVisualFor(q).title(l10n)),
                                ),
                              )
                              .toList(growable: false),
                        ),
                      _ActionIconButton(
                        icon: Icons.edit_outlined,
                        tooltip: l10n.editNote,
                        onPressed: disableActions ? null : onEdit,
                      ),
                      _ActionIconButton(
                        icon: Icons.delete_outline_rounded,
                        tooltip: l10n.delete,
                        onPressed: disableActions ? null : onDelete,
                      ),
                      const Spacer(),
                      if (trailing != null) trailing!,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleMove(BuildContext context, AppLocalizations l10n) async {
    final moveHandler = onMove;
    if (moveHandler == null) {
      return;
    }

    final selected = await showModalBottomSheet<QuadrantType>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.moveTo,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final q in QuadrantType.values)
                  if (q != note.quadrantType)
                    ListTile(
                      leading: Icon(quadrantVisualFor(q).icon),
                      title: Text(quadrantVisualFor(q).title(l10n)),
                      onTap: () => Navigator.of(context).pop(q),
                    ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      moveHandler(selected);
    }
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      visualDensity: VisualDensity.compact,
      iconSize: 18,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
