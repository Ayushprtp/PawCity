import 'package:flutter/material.dart';
import 'package:pawcity/core/theme/app_colors.dart';

class AppGradients {
  static const LinearGradient primaryCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
  );

  static const LinearGradient dashboardHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryDim, AppColors.primary, AppColors.primaryContainer],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient softSurface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.surfaceContainerLowest, AppColors.surfaceContainerLow],
  );

  static const LinearGradient warmAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.tertiaryContainer, AppColors.amber],
  );
}