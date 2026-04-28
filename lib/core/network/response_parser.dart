import '../error/app_error.dart';

T parseOrThrow<T>(dynamic data, T Function(dynamic json) parser) {
  try {
    return parser(data);
  } catch (_) {
    throw AppError(
      type: AppErrorType.invalidResponse,
      message: 'Malformed response from server.',
    );
  }
}
