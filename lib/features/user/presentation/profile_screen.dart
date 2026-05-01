import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/utils/app_card.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/color_parser.dart';
import '../../../core/widgets/theme_mode_toggle.dart';
import '../model/user_profile.dart';
import 'widgets/profile_header.dart';
import 'widgets/project_list_widget.dart';
import 'widgets/project_segmented_control.dart';
import 'widgets/level_progress_widget.dart';
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
          final coalitionColor = ColorParser.parseHex(
            user.coalitionColorHex,
            fallback: AppColors.coalitionFallback,
          );

          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _ProfileHeaderDelegate(
                  user: user,
                  coalitionColor: coalitionColor,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InfoRowSection(
                        user: user,
                        coalitionColor: coalitionColor,
                      ),
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
                          itemBuilder: (context, index) => SkillCard(
                            skill: user.skills[index],
                            coalitionColor: coalitionColor,
                          ),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ProfileHeaderDelegate({
    required this.user,
    required this.coalitionColor,
  });

  final UserProfile user;
  final Color coalitionColor;

  @override
  double get maxExtent => 220;

  @override
  double get minExtent => 92;

  @override
  bool shouldRebuild(covariant _ProfileHeaderDelegate oldDelegate) {
    return oldDelegate.user != user || oldDelegate.coalitionColor != coalitionColor;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final avatarSize = lerpDouble(64, 40, t)!;
    final titleSize = lerpDouble(22, 16, t)!;
    final expandedOpacity = (1 - t).clamp(0.0, 1.0);
    final collapsedOpacity = t.clamp(0.0, 1.0);
    final brightness = Theme.of(context).brightness;
    final useCoalition = !user.isStaff && (user.coalitionCoverUrl?.isNotEmpty ?? false);

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (useCoalition)
              Positioned.fill(
                child: Image.network(
                  user.coalitionCoverUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.card(brightness),
                  ),
                ),
              )
            else
              Positioned.fill(
                child: Container(color: AppColors.card(brightness)),
              ),
            if (useCoalition)
              Positioned.fill(
                child: Container(color: AppColors.overlay(brightness)),
              ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundImage:
                          user.imageUrl.isNotEmpty ? NetworkImage(user.imageUrl) : null,
                      child: user.imageUrl.isEmpty
                          ? const Icon(Icons.person, size: 24)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: expandedOpacity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.login,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontSize: titleSize + 4,
                                        color: useCoalition
                                            ? AppColors.textOnImage(brightness)
                                            : AppColors.textPrimary(brightness),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                InfoRow(
                                  icon: Icons.email,
                                  value: user.email,
                                  showLabel: false,
                                  textColor: useCoalition
                                      ? AppColors.textOnImage(brightness)
                                      : null,
                                  iconColor: useCoalition
                                      ? AppColors.iconOnImage(brightness)
                                      : null,
                                ),
                                const SizedBox(height: 6),
                                InfoRow(
                                  icon: Icons.location_on,
                                  value: user.location,
                                  showLabel: false,
                                  textColor: useCoalition
                                      ? AppColors.textOnImage(brightness)
                                      : null,
                                  iconColor: useCoalition
                                      ? AppColors.iconOnImage(brightness)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: collapsedOpacity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.login,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: titleSize,
                                        color: useCoalition
                                            ? AppColors.textOnImage(brightness)
                                            : AppColors.textPrimary(brightness),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Level ${user.level.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: useCoalition
                                            ? AppColors.textOnImage(brightness)
                                            : AppColors.textSecondary(brightness),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRowSection extends StatelessWidget {
  const _InfoRowSection({
    required this.user,
    required this.coalitionColor,
  });

  final UserProfile user;
  final Color coalitionColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final useCoalition = brightness == Brightness.light;
    final valueColor = useCoalition ? coalitionColor : null;
    final iconColor = useCoalition ? coalitionColor : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumn = constraints.maxWidth < 420;
        final children = [
          _InfoCard(
            icon: Icons.account_balance_wallet,
            label: 'Wallet',
            value: user.wallet.toString(),
            valueColor: valueColor,
            iconColor: iconColor,
          ),
          _LevelCard(
            level: user.level,
            coalitionColor: coalitionColor,
            iconColor: iconColor,
            textColor: valueColor,
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

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children.first),
              const SizedBox(width: 12),
              Expanded(child: children.last),
            ],
          ),
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
    this.valueColor,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Align(
        alignment: Alignment.center,
        child: InfoRow(
          icon: icon,
          label: label,
          value: value,
          textColor: valueColor,
          iconColor: iconColor,
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.coalitionColor,
    this.iconColor,
    this.textColor,
  });

  final double? level;
  final Color coalitionColor;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: LevelProgressWidget(
        level: level,
        coalitionColor: coalitionColor,
        iconColor: iconColor,
        textColor: textColor,
      ),
    );
  }
}
