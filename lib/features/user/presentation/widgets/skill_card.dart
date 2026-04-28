import 'package:flutter/material.dart';

import '../../../../core/utils/app_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../model/skill.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({super.key, required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final progress = (skill.level / 20).clamp(0.0, 1.0);
    final brightness = Theme.of(context).brightness;

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.textPrimary(brightness)),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 8),
          Text(
            'Level: ${skill.level.toStringAsFixed(2)}',
            style: TextStyle(color: AppColors.textSecondary(brightness)),
          ),
        ],
      ),
    );
  }
}
