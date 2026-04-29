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
        final coalition = await _api.getCoalitionData(user.id, cancelToken: cancelToken);
        if (coalition?.coverUrl != null) {
          debugPrint('Coalition cover_url: ${coalition!.coverUrl}');
        }
        if (coalition?.colorHex != null) {
          debugPrint('Coalition color: ${coalition!.colorHex}');
        }
        return user.copyWith(
          coalitionCoverUrl: coalition?.coverUrl,
          coalitionColorHex: coalition?.colorHex,
        );
      } catch (error) {
        debugPrint('Coalition fetch failed: $error');
        return user;
      }
    } on DioException catch (error) {
      throw AppError.fromDio(error);
    }
  }
}
