import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_bottom_nav.dart';
import 'package:pawcity/shared/widgets/paw_glass_top_bar.dart';

class PawScaffold extends StatelessWidget {
  const PawScaffold({
    required this.title,
    required this.body,
    super.key,
    this.actions = const [],
    this.showBottomNav = true,
    this.currentNavIndex = 0,
    this.showBackButton = false,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final bool showBottomNav;
  final int currentNavIndex;
  final bool showBackButton;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PawGlassTopBar(
        title: title,
        actions: actions,
        showBackButton: showBackButton,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNav
          ? PawBottomNav(
              currentIndex: currentNavIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/community-feed');
                    break;
                  case 2:
                    context.go('/paws-explore');
                    break;
                  case 3:
                    context.go('/shop');
                    break;
                  case 4:
                    context.go('/my-pets');
                    break;
                }
              },
            )
          : null,
    );
  }
}