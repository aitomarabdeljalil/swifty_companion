import 'package:flutter/material.dart';

import '../../../../core/utils/app_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../model/skill.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({
    super.key,
    required this.skill,
    required this.coalitionColor,
  });

  final Skill skill;
  final Color coalitionColor;

  @override
  Widget build(BuildContext context) {
    final progress = (skill.level / 20).clamp(0.0, 1.0);
    final brightness = Theme.of(context).brightness;
    final useCoalition = brightness == Brightness.light;
    final accentColor = useCoalition ? coalitionColor : AppColors.textSecondary(brightness);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.code,
                size: 20,
                color: accentColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  skill.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        color: useCoalition
                            ? coalitionColor
                            : AppColors.textPrimary(brightness),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: coalitionColor,
              backgroundColor: AppColors.card(brightness),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Level: ${skill.level.toStringAsFixed(2)}',
            style: TextStyle(
              color: useCoalition ? coalitionColor : AppColors.textSecondary(brightness),
            ),
          ),
        ],
      ),
    );
  }
}
