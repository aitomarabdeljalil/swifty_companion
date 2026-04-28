class AuthState {
  const AuthState({
    this.hasValidToken = false,
    this.message,
  });

  final bool hasValidToken;
  final String? message;

  AuthState copyWith({
    bool? hasValidToken,
    String? message,
  }) {
    return AuthState(
      hasValidToken: hasValidToken ?? this.hasValidToken,
      message: message,
    );
  }
}
