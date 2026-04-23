import 'package:flutter/material.dart';
import 'package:pawcity/core/theme/app_colors.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primaryDark;
  final Color primaryGreen;
  final Color amber;
  final Color white;
  final Color lightBg;

  final Color restaurant;
  final Color park;
  final Color vet;
  final Color grooming;
  final Color boarding;
  final Color petStore;

  final Color severityLow;
  final Color severityMedium;
  final Color severityHigh;
  final Color severityCritical;

  final Color statusSubmitted;
  final Color statusReview;
  final Color statusAssigned;
  final Color statusInProgress;
  final Color statusResolved;

  final Color primary;
  final Color primaryDim;
  final Color primaryContainer;

  final Color secondary;
  final Color secondaryContainer;

  final Color tertiary;
  final Color tertiaryContainer;

  final Color background;
  final Color surface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;

  final Color onSurface;
  final Color onSurfaceVariant;

  final Color outline;
  final Color outlineVariant;

  final Color error;
  final Color errorContainer;

  final Color glassTint;
  final Color glassTintDark;

  const AppColorsExtension({
    required this.primaryDark,
    required this.primaryGreen,
    required this.amber,
    required this.white,
    required this.lightBg,
    required this.restaurant,
    required this.park,
    required this.vet,
    required this.grooming,
    required this.boarding,
    required this.petStore,
    required this.severityLow,
    required this.severityMedium,
    required this.severityHigh,
    required this.severityCritical,
    required this.statusSubmitted,
    required this.statusReview,
    required this.statusAssigned,
    required this.statusInProgress,
    required this.statusResolved,
    required this.primary,
    required this.primaryDim,
    required this.primaryContainer,
    required this.secondary,
    required this.secondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.background,
    required this.surface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.errorContainer,
    required this.glassTint,
    required this.glassTintDark,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primaryDark,
    Color? primaryGreen,
    Color? amber,
    Color? white,
    Color? lightBg,
    Color? restaurant,
    Color? park,
    Color? vet,
    Color? grooming,
    Color? boarding,
    Color? petStore,
    Color? severityLow,
    Color? severityMedium,
    Color? severityHigh,
    Color? severityCritical,
    Color? statusSubmitted,
    Color? statusReview,
    Color? statusAssigned,
    Color? statusInProgress,
    Color? statusResolved,
    Color? primary,
    Color? primaryDim,
    Color? primaryContainer,
    Color? secondary,
    Color? secondaryContainer,
    Color? tertiary,
    Color? tertiaryContainer,
    Color? background,
    Color? surface,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? error,
    Color? errorContainer,
    Color? glassTint,
    Color? glassTintDark,
  }) {
    return AppColorsExtension(
      primaryDark: primaryDark ?? this.primaryDark,
      primaryGreen: primaryGreen ?? this.primaryGreen,
      amber: amber ?? this.amber,
      white: white ?? this.white,
      lightBg: lightBg ?? this.lightBg,
      restaurant: restaurant ?? this.restaurant,
      park: park ?? this.park,
      vet: vet ?? this.vet,
      grooming: grooming ?? this.grooming,
      boarding: boarding ?? this.boarding,
      petStore: petStore ?? this.petStore,
      severityLow: severityLow ?? this.severityLow,
      severityMedium: severityMedium ?? this.severityMedium,
      severityHigh: severityHigh ?? this.severityHigh,
      severityCritical: severityCritical ?? this.severityCritical,
      statusSubmitted: statusSubmitted ?? this.statusSubmitted,
      statusReview: statusReview ?? this.statusReview,
      statusAssigned: statusAssigned ?? this.statusAssigned,
      statusInProgress: statusInProgress ?? this.statusInProgress,
      statusResolved: statusResolved ?? this.statusResolved,
      primary: primary ?? this.primary,
      primaryDim: primaryDim ?? this.primaryDim,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondary: secondary ?? this.secondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest ?? this.surfaceContainerHighest,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      glassTint: glassTint ?? this.glassTint,
      glassTintDark: glassTintDark ?? this.glassTintDark,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryGreen: Color.lerp(primaryGreen, other.primaryGreen, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      white: Color.lerp(white, other.white, t)!,
      lightBg: Color.lerp(lightBg, other.lightBg, t)!,
      restaurant: Color.lerp(restaurant, other.restaurant, t)!,
      park: Color.lerp(park, other.park, t)!,
      vet: Color.lerp(vet, other.vet, t)!,
      grooming: Color.lerp(grooming, other.grooming, t)!,
      boarding: Color.lerp(boarding, other.boarding, t)!,
      petStore: Color.lerp(petStore, other.petStore, t)!,
      severityLow: Color.lerp(severityLow, other.severityLow, t)!,
      severityMedium: Color.lerp(severityMedium, other.severityMedium, t)!,
      severityHigh: Color.lerp(severityHigh, other.severityHigh, t)!,
      severityCritical: Color.lerp(severityCritical, other.severityCritical, t)!,
      statusSubmitted: Color.lerp(statusSubmitted, other.statusSubmitted, t)!,
      statusReview: Color.lerp(statusReview, other.statusReview, t)!,
      statusAssigned: Color.lerp(statusAssigned, other.statusAssigned, t)!,
      statusInProgress: Color.lerp(statusInProgress, other.statusInProgress, t)!,
      statusResolved: Color.lerp(statusResolved, other.statusResolved, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDim: Color.lerp(primaryDim, other.primaryDim, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryContainer: Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryContainer: Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainerLowest: Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow: Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      glassTint: Color.lerp(glassTint, other.glassTint, t)!,
      glassTintDark: Color.lerp(glassTintDark, other.glassTintDark, t)!,
    );
  }
}

extension AppColorsContextExtension on BuildContext {
  AppColorsExtension get colors => Theme.of(this).extension<AppColorsExtension>()!;
}

// Light colors
const lightAppColors = AppColorsExtension(
  primaryDark: AppColors.primaryDark,
  primaryGreen: AppColors.primaryGreen,
  amber: AppColors.amber,
  white: AppColors.white,
  lightBg: AppColors.lightBg,
  restaurant: AppColors.restaurant,
  park: AppColors.park,
  vet: AppColors.vet,
  grooming: AppColors.grooming,
  boarding: AppColors.boarding,
  petStore: AppColors.petStore,
  severityLow: AppColors.severityLow,
  severityMedium: AppColors.severityMedium,
  severityHigh: AppColors.severityHigh,
  severityCritical: AppColors.severityCritical,
  statusSubmitted: AppColors.statusSubmitted,
  statusReview: AppColors.statusReview,
  statusAssigned: AppColors.statusAssigned,
  statusInProgress: AppColors.statusInProgress,
  statusResolved: AppColors.statusResolved,
  primary: AppColors.primary,
  primaryDim: AppColors.primaryDim,
  primaryContainer: AppColors.primaryContainer,
  secondary: AppColors.secondary,
  secondaryContainer: AppColors.secondaryContainer,
  tertiary: AppColors.tertiary,
  tertiaryContainer: AppColors.tertiaryContainer,
  background: AppColors.background,
  surface: AppColors.surface,
  surfaceContainerLowest: AppColors.surfaceContainerLowest,
  surfaceContainerLow: AppColors.surfaceContainerLow,
  surfaceContainer: AppColors.surfaceContainer,
  surfaceContainerHigh: AppColors.surfaceContainerHigh,
  surfaceContainerHighest: AppColors.surfaceContainerHighest,
  onSurface: AppColors.onSurface,
  onSurfaceVariant: AppColors.onSurfaceVariant,
  outline: AppColors.outline,
  outlineVariant: AppColors.outlineVariant,
  error: AppColors.error,
  errorContainer: AppColors.errorContainer,
  glassTint: AppColors.glassTint,
  glassTintDark: AppColors.glassTintDark,
);

// Dark colors
const darkAppColors = AppColorsExtension(
  primaryDark: AppColors.white,
  primaryGreen: AppColors.primaryGreen,
  amber: AppColors.amber,
  white: AppColors.primaryDark,
  lightBg: Color(0xFF1B232B),
  restaurant: AppColors.restaurant,
  park: AppColors.park,
  vet: AppColors.vet,
  grooming: AppColors.grooming,
  boarding: AppColors.boarding,
  petStore: AppColors.petStore,
  severityLow: AppColors.severityLow,
  severityMedium: AppColors.severityMedium,
  severityHigh: AppColors.severityHigh,
  severityCritical: AppColors.severityCritical,
  statusSubmitted: AppColors.statusSubmitted,
  statusReview: AppColors.statusReview,
  statusAssigned: AppColors.statusAssigned,
  statusInProgress: AppColors.statusInProgress,
  statusResolved: AppColors.statusResolved,
  primary: AppColors.primaryContainer, // swap for dark
  primaryDim: AppColors.primary,
  primaryContainer: AppColors.primaryDark,
  secondary: AppColors.secondaryContainer,
  secondaryContainer: AppColors.primaryDark,
  tertiary: AppColors.tertiaryContainer,
  tertiaryContainer: AppColors.primaryDark,
  background: Color(0xFF0F1418),
  surface: Color(0xFF11151A),
  surfaceContainerLowest: Color(0xFF11151A),
  surfaceContainerLow: Color(0xFF1B232B),
  surfaceContainer: Color(0xFF232B32),
  surfaceContainerHigh: Color(0xFF2B333A),
  surfaceContainerHighest: Color(0xFF333B42),
  onSurface: Color(0xFFE6E9EC),
  onSurfaceVariant: Color(0xFFB0B3B5),
  outline: Color(0xFF828A8F),
  outlineVariant: Color(0xFF40474D),
  error: AppColors.errorContainer,
  errorContainer: AppColors.error,
  glassTint: Color(0x1FFFFFFF),
  glassTintDark: Color(0xCCFFFFFF),
);
