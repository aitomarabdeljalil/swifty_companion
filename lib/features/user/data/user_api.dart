import 'package:dio/dio.dart';

import '../../../core/network/response_parser.dart';
import '../model/coalition.dart';
import '../model/user_profile.dart';

class UserApi {
  UserApi(this._dio);

  final Dio _dio;

  Future<UserProfile> getUserByLogin(String login, {CancelToken? cancelToken}) async {
    final response = await _dio.get(
      '/v2/users/$login',
      cancelToken: cancelToken,
    );
    return parseOrThrow(response.data, (json) => UserProfile.fromApi(json as Map<String, dynamic>));
  }

  Future<CoalitionData?> getCoalitionData(int userId, {CancelToken? cancelToken}) async {
    final response = await _dio.get(
      '/v2/users/$userId/coalitions',
      cancelToken: cancelToken,
    );
    return parseOrThrow(response.data, (json) {
      final list = (json as List?) ?? <dynamic>[];
      if (list.isEmpty) {
        return null;
      }
      final first = list.first as Map<String, dynamic>;
      return CoalitionData(
        coverUrl: first['cover_url'] as String?,
        colorHex: first['color'] as String?,
      );
    });
  }
}
