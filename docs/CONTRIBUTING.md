# Contributing

## Setup

```bash
flutter pub get
flutter analyze
flutter test
flutter test integration_test/app_smoke_test.dart -d macos
```

## Firebase (Phase 2) Local Setup

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=q4-board-prod
```

The repo may include a placeholder `lib/firebase_options.dart` for local-only mode.
Replace it with the generated FlutterFire file when working on cloud features.

## Development Guidelines

- Keep changes scoped and reviewable.
- Add/update localization strings for user-facing text.
- Add tests for logic/data behavior changes.
- Keep UI changes consistent with existing design tokens.
- Update docs when user-facing behavior, developer workflow, or assets change.

## Branding / Visual Assets

Temporary branding assets are generated in-repo.

```bash
# Requires ImageMagick (`magick`).
./tool/generate_branding_assets.sh
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

If macOS integration tests fail with a codesign "resource fork / Finder information" error, run them from a non-cloud-synced path (OneDrive/iCloud metadata can contaminate the built app bundle).

## Pull Requests

- Use clear PR titles and summaries.
- Include screenshots for visible UI changes.
- Confirm `flutter analyze` and `flutter test` pass locally.
- Prefer adding/maintaining integration smoke tests for critical user flows.
