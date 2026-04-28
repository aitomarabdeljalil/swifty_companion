import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/auth_api.dart';
import '../data/auth_repository.dart';

final authConfigProvider = Provider<AuthConfig>((ref) {
  return AuthConfig(
    clientId: dotenv.env['FORTY_TWO_CLIENT_ID'] ?? '',
    clientSecret: dotenv.env['FORTY_TWO_CLIENT_SECRET'] ?? '',
    redirectUri: dotenv.env['FORTY_TWO_REDIRECT_URI'] ?? '',
  );
});

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  return AuthTokenStore();
});

final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.read(authDioProvider);
  return AuthApi(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.read(authApiProvider);
  final config = ref.read(authConfigProvider);
  final store = ref.read(authTokenStoreProvider);
  return AuthRepository(api: api, config: config, tokenStore: store);
});
