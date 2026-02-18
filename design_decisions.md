# Design Decisions (Phase 1)

## 1) Local-first persistence with Hive

Why Hive:
- Fast key-value storage for offline-first note data.
- Simple schema for Phase 1 without backend dependencies.
- Good fit for Flutter Web/Android/macOS local storage requirements.

Implementation choices:
- `notes_box_v1` stores `NoteModel` by `id`.
- `settings_box_v1` stores a single settings record.
- `meta_box` stores schema version.

## 2) Manual ordering strategy (`orderIndex`)

Goal:
- Support free reordering and cross-quadrant moves while persisting manual order.

Approach:
- Each note has a `double orderIndex`.
- Insert/move computes index by interpolation between neighbors.
- New note in quadrant appends using a large step (`+1024`).
- When indices become too close, normalization reassigns sequential spaced indices.

Why this approach:
- Avoids rewriting every note on each reorder.
- Handles drag/drop insertion naturally.

## 3) Drag-drop and reorder UX

Desktop/Web/macOS:
- Each quadrant has drop slots between notes.
- `LongPressDraggable` card + `DragTarget` slots allow:
  - reorder within quadrant
  - move across quadrants

Mobile:
- Quadrants are shown as tabs.
- Reorder within current quadrant via `ReorderableListView` and drag handle.
- Cross-quadrant move via per-card move menu.

Reasoning:
- Desktop needs direct pointer drag across quadrants.
- Mobile gets reliable native reorder gestures and explicit move action.

## 4) State management architecture

- Riverpod + `StateNotifier` controllers.
- `BoardController` manages note actions and board state (search/showDone).
- `SettingsController` manages theme/language/preferences.
- Repositories abstract persistence for testability.

## 5) Migration strategy

- Version stored in Hive `meta_box` (`schema_version`).
- `HiveInitializer._runMigrations(fromVersion, toVersion)` is scaffolded.
- Future schema changes should add explicit stepwise migrations.

## 6) Phase 2 boundaries

Phase 1 intentionally includes only interfaces for future cloud work:
- `AuthService`
- `SyncRepository`

No Firebase runtime integration is included until explicit approval for Phase 2.
