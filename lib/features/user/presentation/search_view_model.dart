import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_error.dart';
import '../../../core/utils/validators.dart';
import '../data/user_repository.dart';
import 'search_state.dart';

class SearchViewModel extends StateNotifier<SearchState> {
  SearchViewModel(this._repository) : super(SearchState.idle());

  final UserRepository _repository;
  CancelToken? _cancelToken;
  int _requestId = 0;

  Future<void> search(String login) async {
    final validation = Validators.login(login);
    if (validation != null) {
      state = state.copyWith(status: SearchStatus.error, errorMessage: validation);
      return;
    }

    _cancelToken?.cancel('New search started');
    _cancelToken = CancelToken();
    final currentRequest = ++_requestId;

    state = state.copyWith(
      status: SearchStatus.loading,
      errorMessage: null,
    );

    try {
      final user = await _repository.getUser(login.trim(), cancelToken: _cancelToken);
      if (currentRequest != _requestId) {
        return;
      }
      state = state.copyWith(
        status: SearchStatus.success,
        user: user,
        lastLogin: login.trim(),
        errorMessage: null,
      );
    } on AppError catch (error) {
      if (currentRequest != _requestId) {
        return;
      }
      if (error.type == AppErrorType.canceled) {
        return;
      }
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: error.message,
      );
    } catch (_) {
      if (currentRequest != _requestId) {
        return;
      }
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Unexpected error. Please try again.',
      );
    }
  }

  void resetStatus() {
    state = state.copyWith(status: SearchStatus.idle, errorMessage: null);
  }

  @override
  void dispose() {
    _cancelToken?.cancel('Disposed');
    super.dispose();
  }
}
