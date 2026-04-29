import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.value,
    this.iconSize = 20,
    this.label,
    this.showLabel = true,
    this.textColor,
    this.iconColor,
  });

  final IconData icon;
  final String value;
  final double iconSize;
  final String? label;
  final bool showLabel;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final displayValue = value.trim().isEmpty ? 'Unavailable' : value;

    final labelText = label ?? '';

    final effectiveTextColor = textColor ?? AppColors.textPrimary(brightness);
    final effectiveIconColor = iconColor ?? AppColors.textSecondary(brightness);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: effectiveIconColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: showLabel
              ? Text.rich(
                  TextSpan(
                    text: '$labelText: ',
                    style: TextStyle(color: AppColors.textSecondary(brightness)),
                    children: [
                      TextSpan(
                        text: displayValue,
                        style: TextStyle(color: effectiveTextColor),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  displayValue,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: effectiveTextColor),
                ),
        ),
      ],
    );
  }
}
