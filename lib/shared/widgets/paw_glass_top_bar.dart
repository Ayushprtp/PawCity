import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class PawGlassTopBar extends StatelessWidget implements PreferredSizeWidget {
  const PawGlassTopBar({
    required this.title,
    super.key,
    this.actions = const [],
    this.showBackButton = false,
    this.bottom,
  });

  final String title;
  final List<Widget> actions;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(AppSizes.radiusLg),
        bottomRight: Radius.circular(AppSizes.radiusLg),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? context.colors.glassTintDark
                : context.colors.glassTint,
            border: Border(
              bottom: BorderSide(
                color: context.colors.outlineVariant.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
          ),
          child: AppBar(
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Ethnocentric',
                letterSpacing: 0.5,
              ),
            ),
            actions: actions,
            automaticallyImplyLeading: true,
            bottom: bottom,
            leading: (showBackButton || canPop)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  )
                : null,
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}