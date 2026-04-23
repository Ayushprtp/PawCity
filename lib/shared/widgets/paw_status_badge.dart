import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class PawStatusBadge extends StatelessWidget {
  const PawStatusBadge({
    required this.label,
    required this.color,
    super.key,
  });

  final String label;
  final Color color;

  factory PawStatusBadge.severity(String label) {
    switch (label.toLowerCase()) {
      case 'critical':
        return const PawStatusBadge(label: 'Critical', color: context.colors.severityCritical);
      case 'high':
        return const PawStatusBadge(label: 'High', color: context.colors.severityHigh);
      case 'medium':
        return const PawStatusBadge(label: 'Medium', color: context.colors.severityMedium);
      default:
        return const PawStatusBadge(label: 'Low', color: context.colors.severityLow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}