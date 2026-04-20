import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      const _CommunityPost(
        author: 'Sarah & Milo',
        category: 'Puppy Training',
        time: '2h ago',
        message:
            "Milo finally mastered 'sit' today. Any tips for moving on to 'stay' outdoors with distractions?",
        likes: 124,
        comments: 28,
        mediaTag: 'Training Moment',
        mediaIcon: Icons.pets_rounded,
      ),
      const _CommunityPost(
        author: 'Dr. David Chen',
        category: 'Expert Advice',
        time: '4h ago',
        message:
            'With temperatures rising, keep walks to early morning or evening and carry extra water. Panting is your first cue to pause.',
        likes: 89,
        comments: 12,
      ),
      const _CommunityPost(
        author: 'Marcus & Jasper',
        category: 'Adventures',
        time: '5h ago',
        message:
            'First hike of the season at Whispering Pines. Jasper found a stream break and refused to leave for ten minutes.',
        likes: 215,
        comments: 45,
        mediaTag: 'Trail Highlights',
        mediaIcon: Icons.landscape_rounded,
      ),
    ];

    return PawScaffold(
      title: 'Community Feed',
      currentNavIndex: 0,
      actions: [
        IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.home_rounded),
        ),
      ],
      body: ListView(
        children: [
          _hero(context),
          const SizedBox(height: AppSizes.sectionGap),
          Row(
            children: [
              _tabChip(context, 'Trending', isActive: true),
              const SizedBox(width: AppSizes.sm),
              _tabChip(context, 'Recent'),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list_rounded, size: 18),
                label: const Text('Filter'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          for (var i = 0; i < posts.length; i++) ...[
            _postCard(context, posts[i]),
            if (i != posts.length - 1) const SizedBox(height: AppSizes.lg),
          ],
          const SizedBox(height: AppSizes.sectionGap),
          _caughtUpCard(context),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: AppGradients.softSurface,
        borderRadius: AppEffects.asymCardRadius,
        boxShadow: AppEffects.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The Community Hearth',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Share moments, ask for advice, and celebrate the joyful reality of pet parenthood.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSizes.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: () => context.go('/write-review'),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('New Post'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xl,
                  vertical: AppSizes.md,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(BuildContext context, String label, {bool isActive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryContainer.withValues(alpha: 0.36) : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            ),
      ),
    );
  }

  Widget _postCard(BuildContext context, _CommunityPost post) {
    return PawAsymCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Center(
                  child: Text(
                    post.author
                        .split(' ')
                        .where((part) => part.isNotEmpty)
                        .take(2)
                        .map((part) => part.characters.first)
                        .join(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppSizes.xxs),
                    Text(
                      '${post.time}  •  ${post.category}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded)),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            post.message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (post.mediaTag != null) ...[
            const SizedBox(height: AppSizes.md),
            Container(
              height: 176,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surfaceContainerHigh,
                    AppColors.surfaceContainerLowest,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLg)),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(post.mediaIcon, color: AppColors.primary, size: 34),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      post.mediaTag!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              _metricAction(context, Icons.favorite_rounded, '${post.likes}'),
              const SizedBox(width: AppSizes.lg),
              _metricAction(context, Icons.chat_bubble_rounded, '${post.comments}'),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricAction(BuildContext context, IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: AppSizes.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _caughtUpCard(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.primary,
            size: 34,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'You\'re all caught up!',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Check back later for updates from your pet community.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CommunityPost {
  const _CommunityPost({
    required this.author,
    required this.category,
    required this.time,
    required this.message,
    required this.likes,
    required this.comments,
    this.mediaTag,
    this.mediaIcon,
  });

  final String author;
  final String category;
  final String time;
  final String message;
  final int likes;
  final int comments;
  final String? mediaTag;
  final IconData? mediaIcon;
}
