import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class ReportMapScreen extends StatelessWidget {
  const ReportMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Report Map',
      currentNavIndex: 1,
      body: Column(
        children: [
          Expanded(
            child: PawAsymCard(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.map_rounded, size: 64),
                  ),
                  Positioned(
                    top: 24,
                    left: 20,
                    child: _marker(AppColors.severityCritical),
                  ),
                  Positioned(
                    top: 90,
                    right: 50,
                    child: _marker(AppColors.severityHigh),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 80,
                    child: _marker(AppColors.severityMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _marker(Color color) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8)],
      ),
    );
  }
}