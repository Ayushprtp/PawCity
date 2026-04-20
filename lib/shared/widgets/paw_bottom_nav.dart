import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';

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
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: NavigationBar(
        height: 72,
        backgroundColor: Colors.transparent,
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.4),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.forum_rounded),
            selectedIcon: Icon(Icons.forum_rounded, color: AppColors.primary),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDim],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.explore_rounded, color: Colors.white, size: 22),
            ),
            label: 'Paws',
          ),
          const NavigationDestination(
            icon: Icon(Icons.shopping_bag_rounded),
            selectedIcon: Icon(Icons.shopping_bag_rounded, color: AppColors.primary),
            label: 'Shop',
          ),
          const NavigationDestination(
            icon: Icon(Icons.pets_rounded),
            selectedIcon: Icon(Icons.pets_rounded, color: AppColors.primary),
            label: 'My Pets',
          ),
        ],
      ),
    );
  }
}