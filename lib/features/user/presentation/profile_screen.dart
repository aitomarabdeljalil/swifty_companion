import 'package:flutter/material.dart';

import '../model/user_profile.dart';
import 'widgets/profile_header.dart';
import 'widgets/project_tile.dart';
import 'widgets/skill_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.login),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 720;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileHeader(user: user),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _InfoCard(label: 'Wallet', value: user.wallet.toString()),
                    _InfoCard(label: 'Level', value: user.level.toStringAsFixed(2)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Skills', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                if (user.skills.isEmpty)
                  const Text('No skills available.')
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 2 : 1,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 3.2,
                    ),
                    itemCount: user.skills.length,
                    itemBuilder: (context, index) => SkillCard(skill: user.skills[index]),
                  ),
                const SizedBox(height: 24),
                Text('Projects', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                if (user.projects.isEmpty)
                  const Text('No projects available.')
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: user.projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => ProjectTile(project: user.projects[index]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
