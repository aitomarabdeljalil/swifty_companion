import 'dart:async';

import '../../../core/error/app_error.dart';
import '../model/auth_token.dart';
import 'auth_api.dart';

class AuthConfig {
  AuthConfig({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
  });

  final String clientId;
  final String clientSecret;
  final String redirectUri;

  bool get isValid => clientId.isNotEmpty && clientSecret.isNotEmpty;
}

class AuthTokenStore {
  AuthToken? _token;

  AuthToken? get token => _token;

  void save(AuthToken token) {
    _token = token;
  }

  void clear() {
    _token = null;
  }
}

class AuthRepository {
  AuthRepository({
    required AuthApi api,
    required AuthConfig config,
    required AuthTokenStore tokenStore,
  })  : _api = api,
        _config = config,
        _tokenStore = tokenStore;

  final AuthApi _api;
  final AuthConfig _config;
  final AuthTokenStore _tokenStore;

  Future<AuthToken?> getValidToken() async {
    return _ensureToken();
  }

  Future<AuthToken?> refreshToken() async {
    return _ensureToken(forceRefresh: true);
  }

  Future<AuthToken?> _ensureToken({bool forceRefresh = false}) async {
    if (!_config.isValid) {
      throw AppError(
        type: AppErrorType.unauthorized,
        message: 'Missing 42 API credentials. Check your .env file.',
      );
    }

    final cached = _tokenStore.token;
    if (!forceRefresh && cached != null && !cached.isExpired) {
      return cached;
    }

    if (_refreshing != null) {
      return _refreshing;
    }

    final completer = Completer<AuthToken?>();
    _refreshing = completer.future;

    try {
      final AuthToken token;
      if (cached?.refreshToken != null) {
        token = await _api.refreshAccessToken(
          clientId: _config.clientId,
          clientSecret: _config.clientSecret,
          refreshToken: cached!.refreshToken!,
        );
      } else {
        token = await _api.fetchClientCredentials(
          clientId: _config.clientId,
          clientSecret: _config.clientSecret,
        );
      }
      _tokenStore.save(token);
      completer.complete(token);
      return token;
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
      rethrow;
    } finally {
      _refreshing = null;
    }
  }

  Future<AuthToken?>? _refreshing;
}
