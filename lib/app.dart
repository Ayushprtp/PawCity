import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/core/constants/app_strings.dart';
import 'package:pawcity/core/router/app_router.dart';
import 'package:pawcity/core/theme/app_theme.dart';
import 'package:pawcity/providers/theme_provider.dart';

class PawCityApp extends ConsumerWidget {
  const PawCityApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: themeMode == AppThemeMode.amoled ? AppTheme.amoled : AppTheme.dark,
      themeMode: themeMode == AppThemeMode.light ? ThemeMode.light : ThemeMode.dark,
      routerConfig: router,
    );
  }
}
