import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_state.dart';
import 'user_providers.dart';
import 'widgets/loading_skeleton.dart';
import 'widgets/login_input_field.dart';
import 'profile_screen.dart';
import '../../../core/widgets/theme_mode_toggle.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SearchState>(searchViewModelProvider, (previous, next) {
      if (next.status == SearchStatus.success && next.user != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ProfileScreen(user: next.user!)))
            .then((_) {
          ref.read(searchViewModelProvider.notifier).resetStatus();
        });
      }
    });

    final state = ref.watch(searchViewModelProvider);
    final isLoading = state.status == SearchStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swifty Companion'),
        actions: const [
          ThemeModeToggle(),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 600 ? 520.0 : constraints.maxWidth;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Search 42 profile',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    LoginInputField(
                      controller: _controller,
                      errorText: state.isInputError ? state.errorMessage : null,
                      onSubmitted: (_) => _onSearch(),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: isLoading ? null : _onSearch,
                      child: isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Search'),
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    if (state.lastLogin != null) ...[
                      const SizedBox(height: 16),
                      Text('Last search: ${state.lastLogin}'),
                    ],
                    const SizedBox(height: 24),
                    if (isLoading) const LoadingSkeleton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSearch() {
    final login = _controller.text;
    ref.read(searchViewModelProvider.notifier).search(login);
  }
}
