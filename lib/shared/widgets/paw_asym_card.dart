import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';

import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class PawAsymCard extends StatelessWidget {
  const PawAsymCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSizes.cardPadding),
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.showBorder = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppEffects.asymCardRadius;
    final effectiveBackgroundColor = backgroundColor ?? context.colors.surfaceContainerLowest;

    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveRadius,
        border: showBorder
            ? Border.all(
                color: context.colors.outlineVariant.withValues(alpha: 0.18),
                width: 1,
              )
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return body;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: effectiveRadius as BorderRadius,
        onTap: onTap,
        child: body,
      ),
    );
  }
}