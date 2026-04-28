import 'package:dio/dio.dart';

import '../../../core/network/response_parser.dart';
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
}
