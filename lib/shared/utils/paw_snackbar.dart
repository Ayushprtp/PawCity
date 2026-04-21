import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';

enum PawSnackBarType { success, error, info, warning }

/// Shows a polished floating snack bar with icon and styled background.
void showPawSnackBar(
  BuildContext context, {
  required String message,
  PawSnackBarType type = PawSnackBarType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  final (IconData icon, Color bg, Color fg) = switch (type) {
    PawSnackBarType.success => (Icons.check_circle_rounded, const Color(0xFF1B5E20), Colors.white),
    PawSnackBarType.error => (Icons.error_rounded, AppColors.error, Colors.white),
    PawSnackBarType.warning => (Icons.warning_amber_rounded, const Color(0xFFF57F17), Colors.white),
    PawSnackBarType.info => (Icons.info_rounded, AppColors.secondary, Colors.white),
  };

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: fg, size: 20),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        margin: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          0,
          AppSizes.lg,
          AppSizes.lg,
        ),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
}
