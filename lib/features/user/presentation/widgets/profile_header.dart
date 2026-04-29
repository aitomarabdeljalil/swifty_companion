import 'package:flutter/material.dart';

import '../../../../core/utils/app_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../model/user_profile.dart';
import 'info_row.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundImage: user.imageUrl.isNotEmpty ? NetworkImage(user.imageUrl) : null,
            child: user.imageUrl.isEmpty ? const Icon(Icons.person, size: 32) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.login,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.textPrimary(brightness)),
                ),
                const SizedBox(height: 8),
                InfoRow(
                  icon: Icons.email,
                  value: user.email,
                  showLabel: false,
                ),
                const SizedBox(height: 6),
                InfoRow(
                  icon: Icons.location_on,
                  value: user.location,
                  showLabel: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
