import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/providers/app_providers.dart';
import 'data/hive/hive_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInitializer.initialize();
  final firebaseBootstrapState = await FirebaseBootstrap.initialize();
  runApp(
    ProviderScope(
      overrides: [
        firebaseBootstrapStateProvider.overrideWithValue(firebaseBootstrapState),
      ],
      child: const Q4BoardApp(),
    ),
  );
}
