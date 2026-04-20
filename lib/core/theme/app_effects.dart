import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';

class AppEffects {
  static BorderRadius get cardRadius => BorderRadius.circular(AppSizes.radiusLg);

  static BorderRadius get asymCardRadius => const BorderRadius.only(
        topLeft: Radius.circular(AppSizes.radiusLg),
        topRight: Radius.circular(AppSizes.radiusXl),
        bottomLeft: Radius.circular(AppSizes.radiusXl),
        bottomRight: Radius.circular(AppSizes.radiusLg),
      );

  static BorderRadius get pillRadius => BorderRadius.circular(AppSizes.radiusFull);

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 28,
      offset: Offset(0, 14),
    ),
  ];

  static const List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
}