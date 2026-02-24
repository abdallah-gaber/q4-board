import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Placeholder Firebase options for Phase 2 wiring.
///
/// Replace this file by running:
/// `flutterfire configure --project=q4-board-prod`
/// and commit the generated `lib/firebase_options.dart`.
class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_WEB_API_KEY',
    appId: 'REPLACE_WITH_FLUTTERFIRE_WEB_APP_ID',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_SENDER_ID',
    projectId: 'q4-board-prod',
    authDomain: 'REPLACE_WITH_FLUTTERFIRE_AUTH_DOMAIN',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_ANDROID_API_KEY',
    appId: 'REPLACE_WITH_FLUTTERFIRE_ANDROID_APP_ID',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_SENDER_ID',
    projectId: 'q4-board-prod',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_IOS_API_KEY',
    appId: 'REPLACE_WITH_FLUTTERFIRE_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_SENDER_ID',
    projectId: 'q4-board-prod',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_STORAGE_BUCKET',
    iosBundleId: 'dev.abdallahgaber.q4board',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_MACOS_API_KEY',
    appId: 'REPLACE_WITH_FLUTTERFIRE_MACOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_SENDER_ID',
    projectId: 'q4-board-prod',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_STORAGE_BUCKET',
    iosBundleId: 'dev.abdallahgaber.q4board',
  );
}
