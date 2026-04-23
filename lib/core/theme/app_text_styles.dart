import 'package:flutter/material.dart';
import 'package:pawcity/core/theme/app_colors.dart';

class AppTextStyles {
  static const display = TextStyle(
    fontFamily: 'San Francisco',
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: AppColors.onSurface,
  );

  static const title = TextStyle(
    fontFamily: 'San Francisco',
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static const body = TextStyle(
    fontFamily: 'San Francisco',
    fontSize: 14,
    height: 1.45,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static const label = TextStyle(
    fontFamily: 'San Francisco',
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.onSurface,
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 40,
      height: 1.1,
      fontWeight: FontWeight.w800,
      color: AppColors.onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 34,
      height: 1.15,
      fontWeight: FontWeight.w800,
      color: AppColors.onSurface,
    ),
    displaySmall: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 30,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 28,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 24,
      height: 1.25,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 20,
      height: 1.3,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 18,
      height: 1.3,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 16,
      height: 1.35,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    titleSmall: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 14,
      height: 1.35,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 16,
      height: 1.45,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 14,
      height: 1.45,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurface,
    ),
    bodySmall: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 12,
      height: 1.4,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceVariant,
    ),
    labelLarge: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 14,
      height: 1.35,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      color: AppColors.onSurface,
    ),
    labelSmall: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 11,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.25,
      color: AppColors.onSurfaceVariant,
    ),
  );
}
