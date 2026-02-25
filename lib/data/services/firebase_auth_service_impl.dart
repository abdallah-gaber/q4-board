import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/services/auth_service.dart';

class FirebaseAuthServiceImpl implements AuthService {
  FirebaseAuthServiceImpl(this._auth);

  final FirebaseAuth _auth;

  @override
  AuthAvailability get availability => AuthAvailability.enabled;

  @override
  AuthSession get currentSession => _mapUser(_auth.currentUser);

  @override
  Stream<AuthSession> watchSession() {
    return Stream<AuthSession>.multi((multi) {
      multi.add(currentSession);
      final authSub = _auth.authStateChanges().listen((user) {
        multi.add(_mapUser(user));
      });
      multi.onCancel = () async {
        await authSub.cancel();
      };
    });
  }

  @override
  Future<void> signIn() async {
    if (_auth.currentUser != null) {
      return;
    }
    await _auth.signInAnonymously();
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  AuthSession _mapUser(User? user) {
    return AuthSession(userId: user?.uid, isAuthenticated: user != null);
  }
}

class UnavailableAuthService implements AuthService {
  const UnavailableAuthService();

  static const _session = AuthSession(userId: null, isAuthenticated: false);

  @override
  AuthAvailability get availability => AuthAvailability.unavailable;

  @override
  AuthSession get currentSession => _session;

  @override
  Stream<AuthSession> watchSession() => Stream<AuthSession>.value(_session);

  @override
  Future<void> signIn() async {
    throw StateError('Firebase auth is not available.');
  }

  @override
  Future<void> signOut() async {}
}
