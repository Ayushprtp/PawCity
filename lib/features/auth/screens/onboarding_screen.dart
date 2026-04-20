import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/constants/app_strings.dart';
import 'package:pawcity/core/router/app_router.dart';
import 'package:pawcity/core/router/route_names.dart';
import 'package:pawcity/features/auth/widgets/auth_cta_button.dart';
import 'package:pawcity/features/auth/widgets/auth_text_field.dart';
import 'package:pawcity/services/onboarding_service.dart';
import 'package:pawcity/services/posthog_service.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSpeciesScreen();
  }
}

class OnboardingSpeciesScreen extends ConsumerStatefulWidget {
  const OnboardingSpeciesScreen({super.key});

  @override
  ConsumerState<OnboardingSpeciesScreen> createState() =>
      _OnboardingSpeciesScreenState();
}

class _OnboardingSpeciesScreenState extends ConsumerState<OnboardingSpeciesScreen> {
  final Set<String> _selected = {AppStrings.onboardingSpeciesDog};

  @override
  void initState() {
    super.initState();
    _trackViewed();
  }

  Future<void> _trackViewed() {
    return PostHogService.track(
      PostHogEvents.onboardingStepViewed,
      properties: {'step': 'species', 'step_index': 1},
    );
  }

  Future<void> _continue() async {
    await PostHogService.track(
      PostHogEvents.onboardingStepContinued,
      properties: {
        'step': 'species',
        'step_index': 1,
        'selected_count': _selected.length,
      },
    );
    if (!mounted) {
      return;
    }
    context.goNamed(RouteNames.onboardingBasicInfo);
  }

  Future<void> _skip() async {
    await PostHogService.track(
      PostHogEvents.onboardingSkipped,
      properties: {'step': 'species', 'step_index': 1},
    );
    if (!mounted) {
      return;
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final species = [
      AppStrings.onboardingSpeciesDog,
      AppStrings.onboardingSpeciesCat,
      AppStrings.onboardingSpeciesBird,
      AppStrings.onboardingSpeciesOther,
    ];

    return _OnboardingScaffold(
      stepIndex: 0,
      title: AppStrings.onboardingSpeciesTitle,
      body: AppStrings.onboardingSpeciesBody,
      primaryLabel: AppStrings.continueText,
      onPrimaryPressed: _continue,
      onSkipPressed: _skip,
      child: Wrap(
        spacing: AppSizes.sm,
        runSpacing: AppSizes.sm,
        children: species.map((item) {
          final selected = _selected.contains(item);
          return FilterChip(
            selected: selected,
            onSelected: (_) {
              setState(() {
                if (selected) {
                  _selected.remove(item);
                  if (_selected.isEmpty) {
                    _selected.add(item);
                  }
                } else {
                  _selected.add(item);
                }
              });
            },
            label: Text(item),
          );
        }).toList(),
      ),
    );
  }
}

class OnboardingBasicInfoScreen extends ConsumerStatefulWidget {
  const OnboardingBasicInfoScreen({super.key});

  @override
  ConsumerState<OnboardingBasicInfoScreen> createState() =>
      _OnboardingBasicInfoScreenState();
}

class _OnboardingBasicInfoScreenState
    extends ConsumerState<OnboardingBasicInfoScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trackViewed();
  }

  Future<void> _trackViewed() {
    return PostHogService.track(
      PostHogEvents.onboardingStepViewed,
      properties: {'step': 'basic_info', 'step_index': 2},
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    await PostHogService.track(
      PostHogEvents.onboardingStepContinued,
      properties: {
        'step': 'basic_info',
        'step_index': 2,
        'has_name': _nameController.text.trim().isNotEmpty,
        'has_city': _cityController.text.trim().isNotEmpty,
      },
    );
    if (!mounted) {
      return;
    }
    context.goNamed(RouteNames.onboardingHealthActivity);
  }

  Future<void> _skip() async {
    await PostHogService.track(
      PostHogEvents.onboardingSkipped,
      properties: {'step': 'basic_info', 'step_index': 2},
    );
    if (!mounted) {
      return;
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      stepIndex: 1,
      title: AppStrings.onboardingBasicInfoTitle,
      body: AppStrings.onboardingBasicInfoBody,
      primaryLabel: AppStrings.continueText,
      onPrimaryPressed: _continue,
      onSkipPressed: _skip,
      child: Column(
        children: [
          AuthTextField(label: AppStrings.fullName, controller: _nameController),
          const SizedBox(height: AppSizes.md),
          AuthTextField(label: AppStrings.city, controller: _cityController),
        ],
      ),
    );
  }
}

class OnboardingHealthActivityScreen extends ConsumerStatefulWidget {
  const OnboardingHealthActivityScreen({super.key});

  @override
  ConsumerState<OnboardingHealthActivityScreen> createState() =>
      _OnboardingHealthActivityScreenState();
}

class _OnboardingHealthActivityScreenState
    extends ConsumerState<OnboardingHealthActivityScreen> {
  final Set<String> _goals = {AppStrings.onboardingGoalDailyWalks};

  @override
  void initState() {
    super.initState();
    _trackViewed();
  }

  Future<void> _trackViewed() {
    return PostHogService.track(
      PostHogEvents.onboardingStepViewed,
      properties: {'step': 'health_activity', 'step_index': 3},
    );
  }

  Future<void> _continue() async {
    await PostHogService.track(
      PostHogEvents.onboardingStepContinued,
      properties: {
        'step': 'health_activity',
        'step_index': 3,
        'selected_count': _goals.length,
      },
    );
    if (!mounted) {
      return;
    }
    context.goNamed(RouteNames.onboardingPhotoUpload);
  }

  Future<void> _skip() async {
    await PostHogService.track(
      PostHogEvents.onboardingSkipped,
      properties: {'step': 'health_activity', 'step_index': 3},
    );
    if (!mounted) {
      return;
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final goals = [
      AppStrings.onboardingGoalDailyWalks,
      AppStrings.onboardingGoalWeightControl,
      AppStrings.onboardingGoalVetReminders,
      AppStrings.onboardingGoalSocialPlay,
    ];

    return _OnboardingScaffold(
      stepIndex: 2,
      title: AppStrings.onboardingHealthActivityTitle,
      body: AppStrings.onboardingHealthActivityBody,
      primaryLabel: AppStrings.continueText,
      onPrimaryPressed: _continue,
      onSkipPressed: _skip,
      child: Wrap(
        spacing: AppSizes.sm,
        runSpacing: AppSizes.sm,
        children: goals.map((item) {
          final selected = _goals.contains(item);
          return FilterChip(
            selected: selected,
            onSelected: (_) {
              setState(() {
                if (selected) {
                  _goals.remove(item);
                  if (_goals.isEmpty) {
                    _goals.add(item);
                  }
                } else {
                  _goals.add(item);
                }
              });
            },
            label: Text(item),
          );
        }).toList(),
      ),
    );
  }
}

class OnboardingPhotoUploadScreen extends ConsumerStatefulWidget {
  const OnboardingPhotoUploadScreen({super.key});

  @override
  ConsumerState<OnboardingPhotoUploadScreen> createState() =>
      _OnboardingPhotoUploadScreenState();
}

class _OnboardingPhotoUploadScreenState
    extends ConsumerState<OnboardingPhotoUploadScreen> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _trackViewed();
  }

  Future<void> _trackViewed() {
    return PostHogService.track(
      PostHogEvents.onboardingStepViewed,
      properties: {'step': 'photo_upload', 'step_index': 4},
    );
  }

  Future<void> _finish() async {
    setState(() => _isSubmitting = true);
    try {
      await PostHogService.track(
        PostHogEvents.onboardingStepContinued,
        properties: {'step': 'photo_upload', 'step_index': 4},
      );
      await OnboardingService.setCompleted();
      ref.invalidate(onboardingStateProvider);
      await PostHogService.track(
        PostHogEvents.onboardingCompletedEvent,
        properties: {'step_count': 4},
      );
      if (!mounted) {
        return;
      }
      context.go('/login');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _skip() async {
    await PostHogService.track(
      PostHogEvents.onboardingSkipped,
      properties: {'step': 'photo_upload', 'step_index': 4},
    );
    await OnboardingService.setCompleted();
    ref.invalidate(onboardingStateProvider);
    await PostHogService.track(
      PostHogEvents.onboardingCompletedEvent,
      properties: {'step_count': 4, 'completed_via_skip': true},
    );
    if (!mounted) {
      return;
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      stepIndex: 3,
      title: AppStrings.onboardingPhotoUploadTitle,
      body: AppStrings.onboardingPhotoUploadBody,
      primaryLabel: AppStrings.onboardingFinish,
      onPrimaryPressed: _finish,
      onSkipPressed: _skip,
      isPrimaryLoading: _isSubmitting,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          children: [
            const Icon(Icons.add_a_photo_outlined, size: 36),
            const SizedBox(height: AppSizes.sm),
            Text(
              AppStrings.onboardingAddPhoto,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingScaffold extends StatelessWidget {
  const _OnboardingScaffold({
    required this.stepIndex,
    required this.title,
    required this.body,
    required this.child,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    required this.onSkipPressed,
    this.isPrimaryLoading = false,
  });

  final int stepIndex;
  final String title;
  final String body;
  final Widget child;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSkipPressed;
  final bool isPrimaryLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(4, (idx) {
                  final isActive = idx <= stepIndex;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: idx == 3 ? 0 : AppSizes.xs,
                      ),
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSizes.xl),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSizes.sm),
              Text(body, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppSizes.xl),
              child,
              const SizedBox(height: AppSizes.xl),
              AuthCtaButton(
                label: primaryLabel,
                onPressed: onPrimaryPressed,
                isLoading: isPrimaryLoading,
              ),
              const SizedBox(height: AppSizes.sm),
              Center(
                child: TextButton(
                  onPressed: onSkipPressed,
                  child: const Text(AppStrings.skip),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
