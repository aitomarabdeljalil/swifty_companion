import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/app_error.dart';
import '../model/user_profile.dart';
import 'user_api.dart';

class UserRepository {
  UserRepository(this._api);

  final UserApi _api;

  Future<UserProfile> getUser(String login, {CancelToken? cancelToken}) async {
    try {
      final user = await _api.getUserByLogin(login, cancelToken: cancelToken);
      if (user.isStaff || user.id == 0) {
        return user;
      }
      try {
        final coverUrl = await _api.getCoalitionCoverUrl(user.id, cancelToken: cancelToken);
        if (coverUrl != null) {
          debugPrint('Coalition cover_url: $coverUrl');
        }
        return user.copyWith(coalitionCoverUrl: coverUrl);
      } catch (error) {
        debugPrint('Coalition fetch failed: $error');
        return user;
      }
    } on DioException catch (error) {
      throw AppError.fromDio(error);
    }
  }
}
