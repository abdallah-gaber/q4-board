# Architecture Overview

Q4 Board uses a feature-first structure with clear domain/data boundaries.

## Layers

- `domain/`: core models and contracts (repositories/services)
- `data/`: local persistence (Hive adapters/models + repository impl)
- `features/`: screen-specific presentation + controllers
- `core/`: routing, design tokens, theme, shared helpers

## State Management

- Riverpod with focused providers and controllers.
- Board state and settings state are isolated for predictable updates.

## Persistence

- Hive boxes store notes and app settings.
- Schema/version metadata is tracked through a meta box.
- Local repair and recovery paths are implemented for corrupted note records.

## Cloud Sync (Phase 2)

- Firebase bootstrap is runtime-safe: app falls back to local-only mode when `firebase_options.dart` is still a placeholder.
- Auth uses Firebase anonymous sign-in for initial cross-device sync support.
- Firestore sync is currently manual (`Push` / `Pull`) from Settings.
- Merge behavior uses last-write-wins by `updatedAt` with a safety guard that avoids wiping local notes when remote is empty.

## Testing Strategy

- `test/`: unit and widget tests for repositories/controllers/UI rendering
- `integration_test/`: smoke flows for core user journeys (add note/filter behavior and future regression coverage)

## Platform Support

- Web
- Android
- macOS

(Phase 2 is currently in progress; auth + manual sync foundations are now present.)
