import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:q4_board/data/repositories/firestore_sync_repository_impl.dart';
import 'package:q4_board/domain/entities/note_entity.dart';
import 'package:q4_board/domain/enums/quadrant_type.dart';
import 'package:q4_board/firebase_options.dart';

import 'helpers/in_memory_repositories.dart';

const bool _runEmulatorSyncTest = bool.fromEnvironment(
  'RUN_FIREBASE_EMULATOR_SYNC_TEST',
  defaultValue: false,
);
const String _emulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: '127.0.0.1',
);
const int _firestorePort = int.fromEnvironment(
  'FIRESTORE_EMULATOR_PORT',
  defaultValue: 8080,
);
const int _authPort = int.fromEnvironment(
  'FIREBASE_AUTH_EMULATOR_PORT',
  defaultValue: 9099,
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'firebase emulator: anonymous auth + push/pull roundtrip',
    (tester) async {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      await auth.useAuthEmulator(_emulatorHost, _authPort);
      firestore.useFirestoreEmulator(_emulatorHost, _firestorePort);
      firestore.settings = const Settings(persistenceEnabled: false);

      await auth.signOut();
      await auth.signInAnonymously();
      expect(auth.currentUser, isNotNull);

      final localA = InMemoryNoteRepository();
      final repoA = FirestoreSyncRepositoryImpl(
        firestore: firestore,
        auth: auth,
        localNoteRepository: localA,
      );
      addTearDown(() async {
        await auth.signOut();
        await localA.dispose();
      });

      final now = DateTime.now();
      await localA.upsert(
        NoteEntity(
          id: 'demo-a',
          quadrantType: QuadrantType.iu,
          title: 'Ship release notes',
          description: 'Emulator sync smoke test',
          dueAt: now.add(const Duration(days: 1)),
          isDone: false,
          orderIndex: 10,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await localA.upsert(
        NoteEntity(
          id: 'demo-b',
          quadrantType: QuadrantType.inu,
          title: 'Plan sprint',
          description: null,
          dueAt: null,
          isDone: true,
          orderIndex: 20,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final pushResult = await repoA.push();
      expect(pushResult.upserts, greaterThanOrEqualTo(2));

      final localB = InMemoryNoteRepository();
      final repoB = FirestoreSyncRepositoryImpl(
        firestore: firestore,
        auth: auth,
        localNoteRepository: localB,
      );
      addTearDown(localB.dispose);

      final pullResult = await repoB.pull();
      final pulled = await localB.getAllNotes();

      expect(pullResult.upserts, greaterThanOrEqualTo(2));
      expect(pulled.length, greaterThanOrEqualTo(2));
      expect(pulled.any((note) => note.id == 'demo-a'), isTrue);
      expect(pulled.any((note) => note.id == 'demo-b' && note.isDone), isTrue);
    },
    skip: !_runEmulatorSyncTest,
  );
}
