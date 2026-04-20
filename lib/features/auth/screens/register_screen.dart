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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final auth = ref.read(authServiceProvider);
      await auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        fullName: _nameController.text.trim(),
        city: _cityController.text.trim(),
      );
      await PostHogService.track(PostHogEvents.userSignedUp);
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
            child: PawAsymCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.register,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    AppStrings.appTagline,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  AuthTextField(
                    label: AppStrings.fullName,
                    controller: _nameController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AuthTextField(
                    label: AppStrings.username,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: AppSizes.md),
                  AuthTextField(
                    label: AppStrings.city,
                    controller: _cityController,
                  ),
                  const SizedBox(height: AppSizes.md),
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
                    label: AppStrings.createAccount,
                    onPressed: _register,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(AppStrings.alreadyHaveAccount),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text(AppStrings.loginNow),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}