# Q4 Board

Q4 Board is a bilingual (Arabic/English) Flutter app that applies the Eisenhower Matrix using a 4-quadrant board with sticky-note cards.

## Phase 1 Scope

Implemented in this repository:
- Local-first MVP (Hive, no auth/sync)
- Eisenhower board (Q1/Q2/Q3/Q4)
- Search across notes
- Show Done filter (persisted default)
- Add/edit/delete notes
- Move notes across quadrants
- Undo delete and undo move
- Manual ordering persistence (`orderIndex`)
- Responsive UI:
  - Desktop/Web/macOS: 2x2 quadrant grid with drag-drop + reorder
  - Mobile: tabs with reorder + move menu
- Settings screen:
  - Theme mode (System/Light/Dark)
  - Default Show Done preference
  - Language mode (System/English/Arabic)
- Phase 2 placeholders only:
  - `AuthService` interface
  - `SyncRepository` interface

## Tech Stack

- Flutter (Web + Android + macOS)
- Riverpod
- Hive
- GoRouter
- Flutter localization (`arb`)

## Bundle / Application IDs

- Android namespace + application id: `dev.abdallahgaber.q4board`
- macOS bundle id: `dev.abdallahgaber.q4board`

Note: platform identifiers cannot contain `-`, so the canonical package form is used.

## Project Structure

```text
lib/
  core/
    design/
    providers/
    theme/
    utils/
  data/
    datasources/local/
    hive/
      adapters/
      models/
    repositories/
  domain/
    entities/
    enums/
    repositories/
    services/
  features/
    board/
      controllers/
      presentation/
    note_editor/
      presentation/
    settings/
      controllers/
      presentation/
  l10n/
```

## Run

```bash
flutter pub get
flutter run -d chrome
# or
flutter run -d android
# or
flutter run -d macos
```

## Test & Quality

```bash
flutter analyze
flutter test
```

Implemented tests:
- unit tests for repository implementations
- unit tests for board controller logic
- widget test verifying 4 quadrants render and adding a note works

## Localization

- English: `lib/l10n/app_en.arb`
- Arabic: `lib/l10n/app_ar.arb`

## Notes

- Firebase project `q4-board-prod` is intentionally not integrated yet.
- Sync controls are shown as coming soon in Settings.
