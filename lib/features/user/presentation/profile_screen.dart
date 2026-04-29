import 'package:flutter/material.dart';

import '../../../core/utils/app_card.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/theme_mode_toggle.dart';
import '../model/user_profile.dart';
import 'widgets/profile_header.dart';
import 'widgets/project_list_widget.dart';
import 'widgets/project_segmented_control.dart';
import 'widgets/skill_card.dart';
import 'widgets/info_row.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final UserProfile user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProjectFilter _filter = ProjectFilter.core;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.login),
        actions: const [
          ThemeModeToggle(),
        ],
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
                _InfoRowSection(user: user),
                const SizedBox(height: 24),
                Text(
                  'Skills',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.textPrimary(brightness)),
                ),
                const SizedBox(height: 12),
                if (user.skills.isEmpty)
                  Text(
                    'No skills available.',
                    style: TextStyle(color: AppColors.textSecondary(brightness)),
                  )
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
                Text(
                  'Projects',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.textPrimary(brightness)),
                ),
                const SizedBox(height: 12),
                ProjectSegmentedControl(
                  value: _filter,
                  onChanged: (value) => setState(() => _filter = value),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: ProjectListWidget(
                    key: ValueKey(_filter),
                    projects: user.projects,
                    filter: _filter,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRowSection extends StatelessWidget {
  const _InfoRowSection({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumn = constraints.maxWidth < 420;
        final children = [
          _InfoCard(
            icon: Icons.account_balance_wallet,
            label: 'Wallet',
            value: user.wallet.toString(),
          ),
          _InfoCard(
            icon: Icons.trending_up,
            label: 'Level',
            value: user.level.toStringAsFixed(2),
          ),
        ];

        if (useColumn) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              children.first,
              const SizedBox(height: 12),
              children.last,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: children.first),
            const SizedBox(width: 12),
            Expanded(child: children.last),
          ],
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: InfoRow(
        icon: icon,
        label: label,
        value: value,
      ),
    );
  }
}
