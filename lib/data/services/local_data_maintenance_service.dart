import 'package:hive/hive.dart';

import '../../domain/enums/quadrant_type.dart';
import '../hive/hive_initializer.dart';
import '../hive/models/app_settings_model.dart';
import '../hive/models/note_model.dart';

class LocalDataMaintenanceService {
  const LocalDataMaintenanceService();

  Future<void> resetAllLocalData() {
    return HiveInitializer.resetLocalData();
  }

  Future<int> loadDemoData() async {
    await _ensureBoxesOpen();

    final notesBox = Hive.box<NoteModel>(HiveInitializer.notesBoxName);
    await notesBox.clear();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 12);

    final notes = <NoteModel>[
      NoteModel(
        id: 'demo-q1-1',
        quadrantType: QuadrantType.iu,
        title: 'Prepare launch hotfix',
        description: 'Review crash logs and ship patch before standup.',
        dueAt: today.add(const Duration(days: 2)),
        isDone: false,
        orderIndex: 0,
        createdAt: now,
        updatedAt: now,
      ),
      NoteModel(
        id: 'demo-q1-2',
        quadrantType: QuadrantType.iu,
        title: 'Pay infrastructure invoice',
        description: null,
        dueAt: null,
        isDone: true,
        orderIndex: 1024,
        createdAt: now,
        updatedAt: now,
      ),
      NoteModel(
        id: 'demo-q2-1',
        quadrantType: QuadrantType.inu,
        title: 'Plan Q4 goals',
        description: 'Draft milestones for the next 6 weeks.',
        dueAt: today.subtract(const Duration(days: 1)),
        isDone: false,
        orderIndex: 20000,
        createdAt: now,
        updatedAt: now,
      ),
      NoteModel(
        id: 'demo-q2-2',
        quadrantType: QuadrantType.inu,
        title: 'Read architecture notes',
        description: null,
        dueAt: null,
        isDone: false,
        orderIndex: 21024,
        createdAt: now,
        updatedAt: now,
      ),
      NoteModel(
        id: 'demo-q3-1',
        quadrantType: QuadrantType.niu,
        title: 'Delegate UI copy review',
        description: 'Assign to content team and track by EOD.',
        dueAt: null,
        isDone: true,
        orderIndex: 40000,
        createdAt: now,
        updatedAt: now,
      ),
      NoteModel(
        id: 'demo-q3-2',
        quadrantType: QuadrantType.niu,
        title: 'Reply to vendor email thread',
        description: null,
        dueAt: null,
        isDone: false,
        orderIndex: 41024,
        createdAt: now,
        updatedAt: now,
      ),
      NoteModel(
        id: 'demo-q4-1',
        quadrantType: QuadrantType.ninu,
        title: 'Mute non-essential Slack channels',
        description: 'Keep only project-critical channels visible.',
        dueAt: null,
        isDone: false,
        orderIndex: 60000,
        createdAt: now,
        updatedAt: now,
      ),
      NoteModel(
        id: 'demo-q4-2',
        quadrantType: QuadrantType.ninu,
        title: 'Archive outdated design drafts',
        description: null,
        dueAt: null,
        isDone: false,
        orderIndex: 61024,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final note in notes) {
      await notesBox.put(note.id, note);
    }

    return notes.length;
  }

  Future<void> _ensureBoxesOpen() async {
    if (!Hive.isBoxOpen(HiveInitializer.notesBoxName)) {
      await Hive.openBox<NoteModel>(HiveInitializer.notesBoxName);
    }
    if (!Hive.isBoxOpen(HiveInitializer.settingsBoxName)) {
      await Hive.openBox<AppSettingsModel>(HiveInitializer.settingsBoxName);
    }
  }
}
