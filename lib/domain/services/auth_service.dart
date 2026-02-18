class AuthSession {
  const AuthSession({required this.userId, required this.isAuthenticated});

  final String? userId;
  final bool isAuthenticated;
}

abstract interface class AuthService {
  Stream<AuthSession> watchSession();

  Future<void> signIn();

  Future<void> signOut();
}
