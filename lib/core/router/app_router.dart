import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/enums/quadrant_type.dart';
import '../../features/board/presentation/board_screen.dart';
import '../../features/note_editor/presentation/note_editor_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/board',
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/board'),
      GoRoute(path: '/board', builder: (_, __) => const BoardScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(
        path: '/editor',
        builder: (_, state) {
          final noteId = state.uri.queryParameters['noteId'];
          final quadrant = QuadrantTypeX.tryParse(
            state.uri.queryParameters['quadrant'],
          );
          return NoteEditorScreen(noteId: noteId, initialQuadrant: quadrant);
        },
      ),
    ],
  ),
);
