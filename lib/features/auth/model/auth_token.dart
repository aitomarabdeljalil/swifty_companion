class AuthToken {
  AuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.createdAt,
    this.refreshToken,
    this.scope,
  });

  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final DateTime createdAt;
  final String? refreshToken;
  final String? scope;

  bool get isExpired {
    final expiry = createdAt.add(Duration(seconds: expiresIn - 30));
    return DateTime.now().isAfter(expiry);
  }

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'] as String? ?? '',
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: (json['expires_in'] as num? ?? 0).toInt(),
      createdAt: DateTime.now(),
      refreshToken: json['refresh_token'] as String?,
      scope: json['scope'] as String?,
    );
  }
}
