import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';

class PawGlassTopBar extends StatelessWidget implements PreferredSizeWidget {
  const PawGlassTopBar({
    required this.title,
    super.key,
    this.actions = const [],
    this.showBackButton = false,
  });

  final String title;
  final List<Widget> actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(AppSizes.radiusLg),
        bottomRight: Radius.circular(AppSizes.radiusLg),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AppBar(
          title: Text(title),
          actions: actions,
          automaticallyImplyLeading: true,
          leading: (showBackButton || canPop)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                )
              : null,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.glassTintDark
              : AppColors.glassTint,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSizes.radiusLg),
              bottomRight: Radius.circular(AppSizes.radiusLg),
            ),
            side: BorderSide(color: AppColors.outlineVariant),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}