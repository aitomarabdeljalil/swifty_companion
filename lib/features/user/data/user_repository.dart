import 'package:dio/dio.dart';

import '../../../core/error/app_error.dart';
import '../model/user_profile.dart';
import 'user_api.dart';

class UserRepository {
  UserRepository(this._api);

  final UserApi _api;

  Future<UserProfile> getUser(String login, {CancelToken? cancelToken}) async {
    try {
      return await _api.getUserByLogin(login, cancelToken: cancelToken);
    } on DioException catch (error) {
      throw AppError.fromDio(error);
    }
  }
}
