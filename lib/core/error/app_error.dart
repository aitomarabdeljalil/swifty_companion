import 'package:dio/dio.dart';

enum AppErrorType {
  network,
  timeout,
  notFound,
  unauthorized,
  invalidResponse,
  canceled,
  unknown,
}

class AppError implements Exception {
  AppError({
    required this.type,
    required this.message,
    this.statusCode,
  });

  final AppErrorType type;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppError(type: $type, message: $message, status: $statusCode)';

  static AppError fromDio(DioException error) {
    if (CancelToken.isCancel(error)) {
      return AppError(type: AppErrorType.canceled, message: 'Request was canceled.');
    }

    final statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppError(
          type: AppErrorType.timeout,
          message: 'Request timed out. Please try again.',
          statusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return AppError(
          type: AppErrorType.network,
          message: 'Network error. Please check your connection.',
          statusCode: statusCode,
        );
      case DioExceptionType.badResponse:
        if (statusCode == 404) {
          return AppError(
            type: AppErrorType.notFound,
            message: 'User not found.',
            statusCode: statusCode,
          );
        }
        if (statusCode == 401 || statusCode == 403) {
          return AppError(
            type: AppErrorType.unauthorized,
            message: 'Authentication failed. Please try again.',
            statusCode: statusCode,
          );
        }
        return AppError(
          type: AppErrorType.invalidResponse,
          message: 'Unexpected server response.',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return AppError(type: AppErrorType.canceled, message: 'Request was canceled.');
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return AppError(
          type: AppErrorType.unknown,
          message: 'Unexpected error occurred.',
          statusCode: statusCode,
        );
    }
  }
}
