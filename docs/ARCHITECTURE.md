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
- Firestore sync supports manual (`Push` / `Pull`) actions from Settings.
- A Firestore snapshot listener can apply remote changes to local storage after sign-in (live remote-to-local sync).
- App resume triggers a throttled auto-pull to reduce stale local state after backgrounding.
- Sync behavior preferences and sync metadata (last sync time/result) are persisted in the app settings store.
- Merge behavior uses last-write-wins by `updatedAt` with a safety guard that avoids wiping local notes when remote is empty.

## Testing Strategy

- `test/`: unit and widget tests for repositories/controllers/UI rendering
- `integration_test/`: smoke flows for core user journeys (add note/filter behavior and future regression coverage)

## Platform Support

- Web
- Android
- macOS

(Phase 2 is currently in progress; auth + manual sync foundations are now present.)
