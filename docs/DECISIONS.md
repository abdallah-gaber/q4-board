# Design Decisions

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
- Draggable cards + drag targets allow reorder and cross-quadrant moves.

Mobile:
- Quadrants are shown as tabs.
- Reorder within current quadrant via `ReorderableListView` and drag handle.
- Cross-quadrant move via per-card move menu.

## 4) State management architecture

- Riverpod + controller pattern.
- Board and settings concerns are separated.
- Repositories abstract persistence for testability.

## 5) Migration strategy

- Version stored in Hive `meta_box` (`schema_version`).
- Explicit migration entrypoint exists in `HiveInitializer`.
- Repair + controlled recovery are implemented for corrupted local records.

## 6) Phase 2 boundaries

Phase 2 is intentionally postponed:
- `AuthService` and `SyncRepository` are interfaces only.
- No Firebase runtime integration in the current phase.
