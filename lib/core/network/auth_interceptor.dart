import 'package:dio/dio.dart';

import '../../features/auth/data/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._authRepository, this._dio);

  final AuthRepository _authRepository;
  final Dio _dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['skipAuth'] == true) {
      handler.next(options);
      return;
    }

    try {
      final token = await _authRepository.getValidToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      }
      handler.next(options);
    } catch (error) {
      handler.reject(DioException(
        requestOptions: options,
        error: error,
      ));
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    if (statusCode == 401 && options.extra['retried'] != true && options.extra['skipAuth'] != true) {
      try {
        final refreshed = await _authRepository.refreshToken();
        if (refreshed != null) {
          final retryOptions = options..extra['retried'] = true;
          retryOptions.headers['Authorization'] = 'Bearer ${refreshed.accessToken}';
          final response = await _dio.fetch(retryOptions);
          handler.resolve(response);
          return;
        }
      } catch (_) {
        // Let the original error bubble up.
      }
    }

    handler.next(err);
  }
}
