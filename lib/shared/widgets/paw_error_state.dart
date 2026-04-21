import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';

/// A polished error state widget with icon, message and optional retry.
class PawErrorState extends StatelessWidget {
  const PawErrorState({
    super.key,
    this.icon = Icons.cloud_off_rounded,
    this.title = 'Something went wrong',
    this.message = 'We couldn\'t load this content. Please check your connection and try again.',
    this.onRetry,
    this.retryLabel = 'Try Again',
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (compact) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.errorContainer.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: AppColors.errorContainer.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(icon, color: AppColors.error, size: 20),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
                child: Text(retryLabel),
              ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Icon(icon, size: 36, color: AppColors.error),
            ),
            const SizedBox(height: AppSizes.xl),
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                width: 180,
                child: PawGradientButton(
                  label: retryLabel,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
