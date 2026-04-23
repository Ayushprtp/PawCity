import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/providers/review_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_text_field.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  const WriteReviewScreen({super.key});
  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  int _rating = 0;
  final _commentC = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() { _commentC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Write a Review',
      showBottomNav: false,
      showBackButton: true,
      body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Place info header
        PawAsymCard(
          backgroundColor: context.colors.secondaryContainer.withValues(alpha: 0.15),
          child: Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: context.colors.vet.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusMd)), child: Icon(Icons.local_hospital_rounded, color: context.colors.vet)),
            const SizedBox(width: AppSizes.md),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('PawCare Vet Clinic', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Text('Veterinary Clinic', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
            ])),
          ]),
        ),
        const SizedBox(height: AppSizes.sectionGap),

        // Star Rating
        Text('Your Rating', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSizes.md),
        Center(child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) =>
          GestureDetector(
            onTap: () => setState(() => _rating = i + 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
              child: AnimatedScale(
                scale: _rating > i ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(i < _rating ? Icons.star_rounded : Icons.star_outline_rounded, size: 44, color: i < _rating ? context.colors.amber : context.colors.outlineVariant),
              ),
            ),
          ),
        ))),
        const SizedBox(height: AppSizes.xs),
        Center(child: Text(
          switch (_rating) { 0 => 'Tap to rate', 1 => 'Poor', 2 => 'Fair', 3 => 'Good', 4 => 'Very Good', _ => 'Excellent!' },
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _rating > 0 ? context.colors.amber : context.colors.onSurfaceVariant),
        )),
        const SizedBox(height: AppSizes.sectionGap),

        // Comment
        Text('Your Review', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSizes.md),
        PawTextField(label: 'Share your experience...', controller: _commentC, maxLines: 5),
        const SizedBox(height: AppSizes.sectionGap),

        // Photo upload area
        Text('Add Photos', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSizes.md),
        Container(
          height: 100, width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: context.colors.outlineVariant, width: 1.5), borderRadius: BorderRadius.circular(AppSizes.radiusMd), color: context.colors.surfaceContainerLow),
          child: InkWell(onTap: () {}, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.add_a_photo_rounded, size: 28, color: context.colors.outline),
            const SizedBox(height: AppSizes.xs),
            Text('Tap to add photos', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.colors.outline)),
          ])),
        ),
        const SizedBox(height: AppSizes.sectionGap),

        PawGradientButton(
          label: 'Submit Review',
          isLoading: _isLoading,
          onPressed: _rating == 0 ? null : () async {
            setState(() => _isLoading = true);
            try {
              // In production, spotId would come from route params
              await ref.read(reviewRepositoryProvider).createReview(spotId: '', rating: _rating, comment: _commentC.text.isNotEmpty ? _commentC.text : null);
              if (!context.mounted) return;
              context.push('/review-submitted');
            } catch (_) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to submit review')));
            } finally {
              if (mounted) setState(() => _isLoading = false);
            }
          },
        ),
        const SizedBox(height: AppSizes.xxl),
      ])),
    );
  }
}