import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

/// A single shimmer bone – a rounded rectangle that pulses.
class PawSkeletonBone extends StatelessWidget {
  const PawSkeletonBone({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh.withValues(alpha: 0.55),
        borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusSm),
      ),
    );
  }
}

/// A skeleton wrapper that adds a shimmer-style animated pulse
/// over its [child] content.
class PawSkeletonShimmer extends StatefulWidget {
  const PawSkeletonShimmer({required this.child, super.key});

  final Widget child;

  @override
  State<PawSkeletonShimmer> createState() => _PawSkeletonShimmerState();
}

class _PawSkeletonShimmerState extends State<PawSkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: 0.4 + (_animation.value * 0.6),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ──────────────────────────────────────────────
// Pre-built skeleton layouts for common patterns
// ──────────────────────────────────────────────

/// Skeleton for a pet card in the pets list.
class PawPetCardSkeleton extends StatelessWidget {
  const PawPetCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return PawSkeletonShimmer(
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: AppEffects.asymCardRadius,
          border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHigh.withValues(alpha: 0.45),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusLg),
                  topRight: Radius.circular(AppSizes.radiusXl),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: PawSkeletonBone(width: 120, height: 18),
                      ),
                      PawSkeletonBone(
                        width: 56,
                        height: 22,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  const Row(
                    children: [
                      PawSkeletonBone(width: 70, height: 20),
                      SizedBox(width: AppSizes.sm),
                      PawSkeletonBone(width: 55, height: 20),
                      SizedBox(width: AppSizes.sm),
                      PawSkeletonBone(width: 60, height: 20),
                    ],
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Row(
                    children: [
                      Expanded(
                        child: PawSkeletonBone(
                          height: 40,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: PawSkeletonBone(
                          height: 40,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: PawSkeletonBone(
                          height: 40,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the community feed post card.
class PawPostCardSkeleton extends StatelessWidget {
  const PawPostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return PawSkeletonShimmer(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.cardPadding),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: AppEffects.asymCardRadius,
          border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row
            Row(
              children: [
                const PawSkeletonBone(
                  width: 46,
                  height: 46,
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PawSkeletonBone(width: 100, height: 14),
                      const SizedBox(height: AppSizes.xs),
                      PawSkeletonBone(
                        width: 140,
                        height: 10,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSm),
                      ),
                    ],
                  ),
                ),
                const PawSkeletonBone(width: 24, height: 24),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            // Message lines
            const PawSkeletonBone(height: 12),
            const SizedBox(height: AppSizes.sm),
            const PawSkeletonBone(width: 240, height: 12),
            const SizedBox(height: AppSizes.sm),
            const PawSkeletonBone(width: 180, height: 12),
            const SizedBox(height: AppSizes.lg),
            // Media placeholder
            PawSkeletonBone(
              height: 160,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            const SizedBox(height: AppSizes.lg),
            // Actions
            const Row(
              children: [
                PawSkeletonBone(width: 50, height: 18),
                SizedBox(width: AppSizes.lg),
                PawSkeletonBone(width: 50, height: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for appointment / list row items.
class PawRowSkeleton extends StatelessWidget {
  const PawRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return PawSkeletonShimmer(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.cardPadding),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: AppEffects.asymCardRadius,
          border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            PawSkeletonBone(
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            const SizedBox(width: AppSizes.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PawSkeletonBone(width: 130, height: 14),
                  SizedBox(height: AppSizes.xs),
                  PawSkeletonBone(width: 80, height: 10),
                ],
              ),
            ),
            PawSkeletonBone(
              width: 60,
              height: 22,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the profile hero card area.
class PawProfileSkeleton extends StatelessWidget {
  const PawProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return PawSkeletonShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero card
          Container(
            padding: const EdgeInsets.all(AppSizes.xl),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh.withValues(alpha: 0.35),
              borderRadius: AppEffects.asymCardRadius,
            ),
            child: Row(
              children: [
                PawSkeletonBone(
                  width: 68,
                  height: 68,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                const SizedBox(width: AppSizes.lg),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PawSkeletonBone(width: 140, height: 18),
                      SizedBox(height: AppSizes.sm),
                      PawSkeletonBone(width: 100, height: 12),
                      SizedBox(height: AppSizes.sm),
                      PawSkeletonBone(width: 80, height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // Stats
          Row(
            children: [
              Expanded(
                child: PawSkeletonBone(
                  height: 72,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: PawSkeletonBone(
                  height: 72,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sectionGap),
          // Action tiles
          PawSkeletonBone(
            height: 56,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          const SizedBox(height: AppSizes.sm),
          PawSkeletonBone(
            height: 56,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          const SizedBox(height: AppSizes.sm),
          PawSkeletonBone(
            height: 56,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for shop product grid cards.
class PawProductCardSkeleton extends StatelessWidget {
  const PawProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return PawSkeletonShimmer(
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: PawSkeletonBone(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.xs,
                AppSizes.md,
                AppSizes.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PawSkeletonBone(width: 60, height: 10),
                  const SizedBox(height: AppSizes.xs),
                  const PawSkeletonBone(height: 14),
                  const SizedBox(height: AppSizes.xs),
                  const PawSkeletonBone(width: 80, height: 10),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    children: [
                      const Expanded(
                        child: PawSkeletonBone(width: 50, height: 16),
                      ),
                      PawSkeletonBone(
                        width: 34,
                        height: 34,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
