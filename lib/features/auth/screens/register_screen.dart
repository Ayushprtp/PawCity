import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/constants/app_strings.dart';
import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/features/auth/widgets/auth_cta_button.dart';
import 'package:pawcity/features/auth/widgets/auth_text_field.dart';
import 'package:pawcity/providers/auth_provider.dart';
import 'package:pawcity/services/posthog_service.dart';

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
    final messenger = ScaffoldMessenger.of(context);

    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _nameController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

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
    } on AppAuthException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.message)),
      );
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Decorative Blobs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.lg),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.onSurface.withValues(alpha: 0.06),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image Header
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radiusXl),
                          topRight: Radius.circular(AppSizes.radiusXl),
                        ),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.all(AppSizes.md),
                          child: Image.asset(
                            'assets/images/pc.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.pets, size: 48, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(AppSizes.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Join Paw City!',
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colorScheme.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              AppStrings.appTagline,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
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
                                Text(
                                  AppStrings.alreadyHaveAccount,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => context.go('/login'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: colorScheme.primary,
                                  ),
                                  child: const Text(
                                    AppStrings.loginNow,
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
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
          ),
        ],
      ),
    );
  }
}