import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

class FirebaseBootstrapState {
  const FirebaseBootstrapState({
    required this.isAvailable,
    required this.isConfigured,
    this.message,
  });

  final bool isAvailable;
  final bool isConfigured;
  final String? message;

  static const notConfigured = FirebaseBootstrapState(
    isAvailable: false,
    isConfigured: false,
  );
}

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<FirebaseBootstrapState> initialize() async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (_looksLikePlaceholder(options)) {
      debugPrint(
        'Q4Board: Firebase not configured. Running in local-only mode. '
        'Replace lib/firebase_options.dart with FlutterFire-generated values.',
      );
      return const FirebaseBootstrapState(
        isAvailable: false,
        isConfigured: false,
        message: 'firebase_not_configured',
      );
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }
      return const FirebaseBootstrapState(
        isAvailable: true,
        isConfigured: true,
      );
    } catch (error) {
      debugPrint('Q4Board: Firebase bootstrap failed: $error');
      return FirebaseBootstrapState(
        isAvailable: false,
        isConfigured: true,
        message: 'firebase_bootstrap_failed',
      );
    }
  }

  static bool _looksLikePlaceholder(FirebaseOptions options) {
    return options.apiKey.startsWith('REPLACE_WITH_') ||
        options.appId.startsWith('REPLACE_WITH_') ||
        options.messagingSenderId.startsWith('REPLACE_WITH_') ||
        (options.projectId.isEmpty);
  }
}
