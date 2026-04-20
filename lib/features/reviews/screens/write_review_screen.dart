import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_text_field.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _headlineController = TextEditingController();
  final _reviewController = TextEditingController();
  int _rating = 4;

  @override
  void dispose() {
    _headlineController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Write a Review',
      currentNavIndex: 0,
      showBottomNav: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PawAsymCard(
              child: Row(
                children: List.generate(
                  5,
                  (index) => IconButton(
                    onPressed: () => setState(() => _rating = index + 1),
                    icon: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            PawAsymCard(
              child: Column(
                children: [
                  PawTextField(label: 'Headline', controller: _headlineController),
                  const SizedBox(height: AppSizes.md),
                  PawTextField(
                    label: 'Share your experience',
                    controller: _reviewController,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sectionGap),
            PawGradientButton(
              label: 'Submit Review',
              onPressed: () => context.go('/review-submitted'),
            ),
          ],
        ),
      ),
    );
  }
}