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
        indicatorColor: AppColors.secondaryContainer,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.campaign_rounded), label: 'Patrol'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_rounded), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.event_note_rounded), label: 'Appointments'),
          NavigationDestination(icon: Icon(Icons.pets_rounded), label: 'Pets'),
        ],
      ),
    );
  }
}