import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/user_api.dart';
import '../data/user_repository.dart';
import 'search_state.dart';
import 'search_view_model.dart';

final userApiProvider = Provider<UserApi>((ref) {
  final dio = ref.read(dioProvider);
  return UserApi(dio);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.read(userApiProvider);
  return UserRepository(api);
});

final searchViewModelProvider = StateNotifierProvider<SearchViewModel, SearchState>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return SearchViewModel(repository);
});
