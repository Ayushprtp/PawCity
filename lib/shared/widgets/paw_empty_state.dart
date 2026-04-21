import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';

/// A reusable empty-state widget with a large icon, title, description, and
/// optional CTA button. Used for "no data" scenarios across the app.
class PawEmptyState extends StatelessWidget {
  const PawEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = iconColor ?? AppColors.outlineVariant;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xxl,
          vertical: AppSizes.sectionGap,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Soft circle background behind the icon
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Icon(icon, size: 42, color: color),
            ),
            const SizedBox(height: AppSizes.xl),
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppSizes.sm),
              Text(
                message!,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSizes.xl),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(actionLabel!),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xl,
                    vertical: AppSizes.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppEffects.pillRadius,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
