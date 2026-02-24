class AuthSession {
  const AuthSession({required this.userId, required this.isAuthenticated});

  final String? userId;
  final bool isAuthenticated;
}

enum AuthAvailability { enabled, unavailable }

abstract interface class AuthService {
  Stream<AuthSession> watchSession();

  AuthSession get currentSession;

  AuthAvailability get availability;

  Future<void> signIn();

  Future<void> signOut();
}
