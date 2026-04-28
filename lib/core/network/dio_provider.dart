import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/constants.dart';
import 'auth_interceptor.dart';
import '../../features/auth/presentation/auth_providers.dart';

final authDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
    ),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
    ),
  );

  dio.interceptors.add(AuthInterceptor(authRepository, dio));

  return dio;
});
