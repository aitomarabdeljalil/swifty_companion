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

    final coverUrl = user.coalitionCoverUrl;
    final useCoalition = !user.isStaff && coverUrl != null && coverUrl.isNotEmpty;

    final content = Row(
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: useCoalition
                    ? AppColors.textOnImage(brightness)
                    : AppColors.textPrimary(brightness),
                    fontWeight: useCoalition ? FontWeight.w700 : FontWeight.w600,
                    shadows: useCoalition
                    ? const [Shadow(blurRadius: 4, color: Colors.black45)]
                    : null,
                  ),
                ),
              const SizedBox(height: 8),
              InfoRow(
                icon: Icons.email,
                value: user.email,
                showLabel: false,
                textColor: useCoalition ? AppColors.textOnImage(brightness) : null,
                iconColor: useCoalition ? AppColors.iconOnImage(brightness) : null,
              ),
              const SizedBox(height: 6),
              InfoRow(
                icon: Icons.location_on,
                value: user.location,
                showLabel: false,
                textColor: useCoalition ? AppColors.textOnImage(brightness) : null,
                iconColor: useCoalition ? AppColors.iconOnImage(brightness) : null,
              ),
            ],
          ),
        ),
      ],
    );

    if (!useCoalition) {
      return AppCard(child: content);
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: Image.network(
                coverUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }
                  return Container(
                    color: AppColors.card(brightness),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.card(brightness),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.white70),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(color: AppColors.overlay(brightness)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
