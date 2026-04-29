import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class LevelProgressWidget extends StatelessWidget {
  const LevelProgressWidget({
    super.key,
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
    if (level == null) {
      return const SizedBox.shrink();
    }

    final brightness = Theme.of(context).brightness;
    final labelColor = textColor ?? AppColors.textPrimary(brightness);
    final effectiveIconColor = iconColor ?? AppColors.textSecondary(brightness);
    final progress = _decimalPart(level!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up, size: 20, color: effectiveIconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Level ${level!.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: labelColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            color: coalitionColor,
            backgroundColor: AppColors.card(brightness),
          ),
        ),
      ],
    );
  }

  double _decimalPart(double value) {
    final fraction = value - value.floorToDouble();
    if (fraction.isNaN || fraction.isInfinite) {
      return 0;
    }
    return fraction.clamp(0, 1);
  }
}
