import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/constants/app_strings.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/features/auth/widgets/auth_cta_button.dart';
import 'package:pawcity/features/auth/widgets/auth_text_field.dart';
import 'package:pawcity/providers/auth_provider.dart';
import 'package:pawcity/services/posthog_service.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final auth = ref.read(authServiceProvider);
      await auth.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await PostHogService.track(PostHogEvents.userLoggedIn);
      if (mounted) {
        context.go('/home');
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.genericError)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softSurface),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.xl),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    child: Image.asset('assets/images/pc.png', height: 96),
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                PawAsymCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.login,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        AppStrings.appTagline,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSizes.xl),
                      AuthTextField(
                        label: AppStrings.email,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: AppSizes.md),
                      AuthTextField(
                        label: AppStrings.password,
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: AppSizes.xl),
                      AuthCtaButton(
                        label: AppStrings.login,
                        onPressed: _login,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(AppStrings.dontHaveAccount),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: const Text(AppStrings.registerNow),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}