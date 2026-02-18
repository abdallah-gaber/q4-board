import 'package:flutter/material.dart';
import 'package:q4_board/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/app_spacing.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/enums/quadrant_type.dart';
import '../../board/controllers/board_controller.dart';
import '../../board/presentation/quadrant_ui.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({
    super.key,
    required this.noteId,
    required this.initialQuadrant,
  });

  final String? noteId;
  final QuadrantType? initialQuadrant;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool _initialized = false;
  late QuadrantType _quadrant;
  DateTime? _dueAt;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _quadrant = widget.initialQuadrant ?? QuadrantType.iu;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final boardState = ref.watch(boardControllerProvider);

    _initFromExisting(boardState.notes);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? l10n.addNote : l10n.editNote),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.title),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return l10n.requiredTitle;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: l10n.description),
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<QuadrantType>(
              initialValue: _quadrant,
              decoration: const InputDecoration(),
              items: QuadrantType.values
                  .map(
                    (quadrant) => DropdownMenuItem(
                      value: quadrant,
                      child: Text(quadrantVisualFor(quadrant).title(l10n)),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _quadrant = value;
                  });
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.dueDate),
              subtitle: Text(
                _dueAt == null
                    ? l10n.noDueDate
                    : _dueAt!.toIso8601String().split('T').first,
              ),
              trailing: Wrap(
                spacing: AppSpacing.xs,
                children: [
                  IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event_rounded),
                    tooltip: l10n.pickDate,
                  ),
                  IconButton(
                    onPressed: () => setState(() => _dueAt = null),
                    icon: const Icon(Icons.clear_rounded),
                    tooltip: l10n.clearDueDate,
                  ),
                ],
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isDone,
              onChanged: (value) => setState(() => _isDone = value),
              title: Text(l10n.markDone),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }

  void _initFromExisting(List<NoteEntity> notes) {
    if (_initialized) {
      return;
    }
    if (widget.noteId == null) {
      _initialized = true;
      return;
    }

    NoteEntity? existing;
    for (final note in notes) {
      if (note.id == widget.noteId) {
        existing = note;
        break;
      }
    }

    if (existing == null) {
      return;
    }

    _titleController.text = existing.title;
    _descriptionController.text = existing.description ?? '';
    _quadrant = existing.quadrantType;
    _dueAt = existing.dueAt;
    _isDone = existing.isDone;
    _initialized = true;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 10),
    );
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      _dueAt = picked;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(boardControllerProvider.notifier)
        .saveNote(
          noteId: widget.noteId,
          quadrantType: _quadrant,
          title: _titleController.text,
          description: _descriptionController.text,
          dueAt: _dueAt,
          isDone: _isDone,
        );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
