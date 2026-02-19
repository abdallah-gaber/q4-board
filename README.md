# Q4 Board — Eisenhower Matrix

Q4 Board is a bilingual productivity app based on the Eisenhower Matrix.
Arabic name: **لوحة الأولويات (مصفوفة آيزنهاور)**.

It helps you classify tasks into 4 quadrants and prioritize execution with a sticky-note board experience.

## Features (Phase 1)

- Local-first storage with Hive (offline by default)
- 4-quadrant Eisenhower board (Q1/Q2/Q3/Q4)
- Manual drag/reorder with persisted ordering
- Move notes between quadrants
- Search across notes
- Show/hide done filtering
- Undo for delete and move actions
- Arabic/English localization (RTL support)
- Light/Dark/System themes
- Responsive UX for web/mobile/desktop

## Tech Stack

- Flutter
- Riverpod
- GoRouter
- Hive
- Flutter i18n (`arb`)

## Getting Started

### Prerequisites

- Flutter SDK installed
- A device/emulator/simulator for your target platform

### Install dependencies

```bash
flutter pub get
```

### Run (Web)

```bash
flutter run -d chrome
```

### Run (Android)

```bash
flutter run -d android
```

### Run (iOS)

```bash
flutter run -d ios
```

### Run (macOS)

```bash
flutter run -d macos
```

## Project Structure

```text
lib/
  core/          # app-wide theme, routing, design tokens, helpers
  domain/        # entities + repository/service contracts
  data/          # Hive models/adapters + repository implementations
  features/      # board, note editor, settings
  l10n/          # ARB files + generated localization output

Docs/
  docs/          # roadmap, architecture, decisions, contributing
```

## Screenshots

![Board Light](docs/screenshots/board_light.png)
![Board Dark](docs/screenshots/board_dark.png)
![Mobile Quadrants](docs/screenshots/mobile_quadrants.png)

Replace placeholders by adding images with the same names.

## Roadmap

- **Phase 1**: Local-first MVP (done)
- **Phase 2**: Authentication + cloud sync (planned)
- **Later phases**: richer planning workflows, productivity insights, and integrations

See [`docs/ROADMAP.md`](docs/ROADMAP.md) for details.

## Known Issues

- Desktop/Web drag can still show a visual jump/snap at drag start in some cases. This is tracked and will be improved in a coming UI iteration.
- Minor drag-feel differences may appear across browsers because pointer/drag behavior differs by engine.

## Quality Checks

```bash
flutter analyze
flutter test
```
