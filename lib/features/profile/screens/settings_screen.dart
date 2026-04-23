import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';
import 'package:pawcity/providers/theme_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return PawScaffold(
      title: 'Settings',
      showBottomNav: false,
      showBackButton: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: AppSizes.md),
            PawAsymCard(
              child: Column(
                children: [
                  _themeOption(
                    context,
                    ref,
                    'Light Mode',
                    Icons.light_mode_rounded,
                    AppThemeMode.light,
                    currentTheme == AppThemeMode.light,
                  ),
                  _divider(context),
                  _themeOption(
                    context,
                    ref,
                    'Dark Mode',
                    Icons.dark_mode_rounded,
                    AppThemeMode.dark,
                    currentTheme == AppThemeMode.dark,
                  ),
                  _divider(context),
                  _themeOption(
                    context,
                    ref,
                    'AMOLED Mode',
                    Icons.auto_awesome_rounded,
                    AppThemeMode.amoled,
                    currentTheme == AppThemeMode.amoled,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sectionGap),
            
            Text('Account',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: AppSizes.md),
            PawAsymCard(
              child: Column(
                children: [
                  _settingsTile(context, 'Edit Profile', Icons.person_outline_rounded),
                  _divider(context),
                  _settingsTile(context, 'Privacy Settings', Icons.lock_outline_rounded),
                  _divider(context),
                  _settingsTile(context, 'Notifications', Icons.notifications_none_rounded),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sectionGap),

            Text('Support',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: AppSizes.md),
            PawAsymCard(
              child: Column(
                children: [
                  _settingsTile(context, 'Help Center', Icons.help_outline_rounded),
                  _divider(context),
                  _settingsTile(context, 'Feedback', Icons.feedback_outlined),
                  _divider(context),
                  _settingsTile(context, 'About PawCity', Icons.info_outline_rounded),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }

  Widget _themeOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    IconData icon,
    AppThemeMode mode,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => ref.read(themeProvider.notifier).setTheme(mode),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isSelected ? context.colors.primary : context.colors.onSurfaceVariant),
            const SizedBox(width: AppSizes.lg),
            Expanded(
              child: Text(label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? context.colors.primary : context.colors.onSurface,
                      )),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: context.colors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(BuildContext context, String label, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        child: Row(
          children: [
            Icon(icon, size: 22, color: context.colors.onSurfaceVariant),
            const SizedBox(width: AppSizes.lg),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ),
            Icon(Icons.chevron_right_rounded, color: context.colors.outlineVariant),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(height: 1, color: context.colors.outlineVariant.withValues(alpha: 0.2));
  }
}
