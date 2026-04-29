import '../model/user_profile.dart';

enum SearchStatus { idle, loading, success, error }

class SearchState {
  const SearchState({
    required this.status,
    this.user,
    this.errorMessage,
    this.lastLogin,
    this.isInputError = false,
  });

  final SearchStatus status;
  final UserProfile? user;
  final String? errorMessage;
  final String? lastLogin;
  final bool isInputError;

  factory SearchState.idle() => const SearchState(status: SearchStatus.idle);

  SearchState copyWith({
    SearchStatus? status,
    UserProfile? user,
    String? errorMessage,
    String? lastLogin,
    bool? isInputError,
  }) {
    return SearchState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      lastLogin: lastLogin ?? this.lastLogin,
      isInputError: isInputError ?? this.isInputError,
    );
  }
}
