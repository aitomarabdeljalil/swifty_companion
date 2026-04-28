import '../model/user_profile.dart';

enum SearchStatus { idle, loading, success, error }

class SearchState {
  const SearchState({
    required this.status,
    this.user,
    this.errorMessage,
    this.lastLogin,
  });

  final SearchStatus status;
  final UserProfile? user;
  final String? errorMessage;
  final String? lastLogin;

  factory SearchState.idle() => const SearchState(status: SearchStatus.idle);

  SearchState copyWith({
    SearchStatus? status,
    UserProfile? user,
    String? errorMessage,
    String? lastLogin,
  }) {
    return SearchState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
