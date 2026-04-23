import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class PawBottomNav extends StatelessWidget {
  const PawBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: NavigationBar(
          height: 72,
          backgroundColor: Colors.transparent,
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          indicatorColor: context.colors.primaryContainer.withValues(alpha: 0.35),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded, color: context.colors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.forum_outlined),
              selectedIcon: Icon(Icons.forum_rounded, color: context.colors.primary),
              label: 'Community',
            ),
            NavigationDestination(
              icon: Container(
                padding: const EdgeInsets.all(10),
               decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.colors.primary, context.colors.primaryDim],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.explore_rounded, color: Colors.white, size: 22),
              ),
              label: 'Paws',
            ),
            NavigationDestination(
              icon: const Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag_rounded, color: context.colors.primary),
              label: 'Shop',
            ),
            NavigationDestination(
              icon: const Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets_rounded, color: context.colors.primary),
              label: 'My Pets',
            ),
          ],
        ),
      ),
    );
  }
}