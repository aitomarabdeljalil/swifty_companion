import 'package:dio/dio.dart';

import '../../../core/network/response_parser.dart';
import '../../../core/utils/constants.dart';
import '../model/auth_token.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<AuthToken> fetchClientCredentials({
    required String clientId,
    required String clientSecret,
  }) async {
    final response = await _dio.post(
      AppConstants.tokenPath,
      data: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        extra: {'skipAuth': true},
      ),
    );

    return parseOrThrow(response.data, (json) => AuthToken.fromJson(json as Map<String, dynamic>));
  }

  Future<AuthToken> fetchAuthorizationCode({
    required String clientId,
    required String clientSecret,
    required String code,
    required String redirectUri,
  }) async {
    final response = await _dio.post(
      AppConstants.tokenPath,
      data: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUri,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        extra: {'skipAuth': true},
      ),
    );

    return parseOrThrow(response.data, (json) => AuthToken.fromJson(json as Map<String, dynamic>));
  }

  Future<AuthToken> refreshAccessToken({
    required String clientId,
    required String clientSecret,
    required String refreshToken,
  }) async {
    final response = await _dio.post(
      AppConstants.tokenPath,
      data: {
        'grant_type': 'refresh_token',
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': refreshToken,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        extra: {'skipAuth': true},
      ),
    );

    return parseOrThrow(response.data, (json) => AuthToken.fromJson(json as Map<String, dynamic>));
  }
}
