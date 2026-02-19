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

## Platform Support

- Web
- Android
- macOS

(Phase 2 sync/auth is intentionally not implemented in this phase.)
