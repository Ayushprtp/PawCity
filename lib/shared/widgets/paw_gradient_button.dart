import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';

class PawGradientButton extends StatelessWidget {
  const PawGradientButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.primaryCta,
        borderRadius: AppEffects.pillRadius,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: AppEffects.pillRadius),
        ),
        child: isLoading
            ? const SizedBox(
                height: AppSizes.iconSm,
                width: AppSizes.iconSm,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}