class AppConstants {
  static const String baseUrl = 'https://api.intra.42.fr';
  static const String tokenPath = '/oauth/token';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
}
