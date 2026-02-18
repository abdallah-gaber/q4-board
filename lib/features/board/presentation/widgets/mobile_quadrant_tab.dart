import 'package:flutter/material.dart';
import 'package:q4_board/l10n/app_localizations.dart';

import '../../../../core/design/app_radii.dart';
import '../../../../core/design/app_spacing.dart';
import '../../../../domain/entities/note_entity.dart';
import '../../../../domain/enums/quadrant_type.dart';
import '../quadrant_ui.dart';
import 'sticky_note_card.dart';

class MobileQuadrantTab extends StatelessWidget {
  const MobileQuadrantTab({
    super.key,
    required this.quadrant,
    required this.notes,
    required this.searchActive,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleDone,
    required this.onMove,
    required this.onReorder,
  });

  final QuadrantType quadrant;
  final List<NoteEntity> notes;
  final bool searchActive;
  final ValueChanged<NoteEntity> onEdit;
  final ValueChanged<NoteEntity> onDelete;
  final ValueChanged<NoteEntity> onToggleDone;
  final void Function(NoteEntity note, QuadrantType targetQuadrant) onMove;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visual = quadrantVisualFor(quadrant);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: visual.panelTint(Theme.of(context).brightness),
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(
                color: visual.accentColor.withValues(alpha: 0.34),
              ),
            ),
            child: Row(
              children: [
                Icon(visual.icon, size: 18),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    visual.title(l10n),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  visual.actionLabel(l10n),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: visual.accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: visual.panelTint(Theme.of(context).brightness),
                        borderRadius: BorderRadius.circular(AppRadii.md),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(visual.icon, size: 30),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            searchActive
                                ? l10n.emptySearch
                                : l10n.emptyQuadrant,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : (searchActive
                      ? ListView.builder(
                          key: PageStorageKey<String>(
                            'mobile-search-${quadrant.name}',
                          ),
                          padding: EdgeInsets.zero,
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return StickyNoteCard(
                              key: ValueKey<String>('mobile-${note.id}'),
                              note: note,
                              visual: visual,
                              onToggleDone: (value) =>
                                  onToggleDone(note.copyWith(isDone: value)),
                              onEdit: () => onEdit(note),
                              onDelete: () => onDelete(note),
                              onMove: (target) => onMove(note, target),
                              moveAsBottomSheet: true,
                            );
                          },
                        )
                      : ReorderableListView.builder(
                          key: PageStorageKey<String>(
                            'mobile-${quadrant.name}',
                          ),
                          itemCount: notes.length,
                          onReorder: onReorder,
                          buildDefaultDragHandles: false,
                          padding: EdgeInsets.zero,
                          proxyDecorator: (child, index, animation) {
                            return Material(
                              color: Colors.transparent,
                              child: AnimatedBuilder(
                                animation: animation,
                                builder: (context, _) {
                                  final t = Curves.easeOut.transform(
                                    animation.value,
                                  );
                                  return Transform.scale(
                                    scale: 1 + (0.03 * t),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return StickyNoteCard(
                              key: ValueKey<String>('mobile-r-${note.id}'),
                              note: note,
                              visual: visual,
                              onToggleDone: (value) =>
                                  onToggleDone(note.copyWith(isDone: value)),
                              onEdit: () => onEdit(note),
                              onDelete: () => onDelete(note),
                              onMove: (target) => onMove(note, target),
                              moveAsBottomSheet: true,
                              trailing: ReorderableDragStartListener(
                                index: index,
                                child: const Icon(Icons.drag_indicator_rounded),
                              ),
                            );
                          },
                        )),
          ),
        ],
      ),
    );
  }
}
