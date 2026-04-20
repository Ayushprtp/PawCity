import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/services/supabase_service.dart';

class CommunityFeedScreen extends ConsumerStatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  ConsumerState<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends ConsumerState<CommunityFeedScreen> {
  late Future<List<Map<String, dynamic>>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    setState(() {
      _postsFuture = SupabaseService.client
          .from('community_posts')
          .select('*, profiles(display_name)')
          .order('created_at', ascending: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Community',
      currentNavIndex: 1,
      actions: [
        IconButton(
          onPressed: () => context.push('/notifications'),
          icon: const Icon(Icons.notifications_outlined),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: () async => _fetchPosts(),
        child: ListView(
          children: [
            _hero(context),
            const SizedBox(height: AppSizes.lg),
            // Quick access cards for Paw Patrol, Lost Pet, Adoption
            _quickAccessSection(context),
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.xl),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                          const SizedBox(height: AppSizes.md),
                          Text('Error loading posts', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: AppSizes.sm),
                          TextButton(onPressed: _fetchPosts, child: const Text('Retry')),
                        ],
                      ),
                    ),
                  );
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.xl),
                      child: Text('No posts yet. Be the first to share!'),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSizes.lg),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final profile = item['profiles'] as Map<String, dynamic>?;
                    final author = profile?['display_name'] ?? 'Anonymous';

                    final createdAt = DateTime.tryParse(item['created_at']?.toString() ?? '')?.toLocal() ?? DateTime.now();
                    final difference = DateTime.now().difference(createdAt);
                    String timeAgo;
                    if (difference.inDays > 0) {
                      timeAgo = '${difference.inDays}d ago';
                    } else if (difference.inHours > 0) {
                      timeAgo = '${difference.inHours}h ago';
                    } else if (difference.inMinutes > 0) {
                      timeAgo = '${difference.inMinutes}m ago';
                    } else {
                      timeAgo = 'Just now';
                    }

                    IconData? mediaIcon;
                    if (item['media_icon'] == 'pets') {
                      mediaIcon = Icons.pets_rounded;
                    } else if (item['media_icon'] == 'landscape') {
                      mediaIcon = Icons.landscape_rounded;
                    }

                    final post = _CommunityPost(
                      author: author,
                      category: item['category']?.toString() ?? 'General',
                      time: timeAgo,
                      message: item['message']?.toString() ?? '',
                      likes: item['likes'] as int? ?? 0,
                      comments: item['comments'] as int? ?? 0,
                      mediaTag: item['media_tag']?.toString(),
                      mediaIcon: mediaIcon,
                    );

                    return _postCard(context, post);
                  },
                );
              },
            ),
            const SizedBox(height: AppSizes.sectionGap),
            _caughtUpCard(context),
          ],
        ),
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
              onPressed: () => context.push('/write-review'),
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

  Widget _quickAccessSection(BuildContext context) {
    final items = [
      const _QuickAction('Paw Patrol', Icons.campaign_rounded, AppColors.error, AppColors.errorContainer, '/paw-patrol'),
      const _QuickAction('Lost Pets', Icons.search_rounded, AppColors.secondary, AppColors.secondaryContainer, '/lost-pet'),
      const _QuickAction('Adopt', Icons.volunteer_activism_rounded, AppColors.tertiary, AppColors.tertiaryContainer, '/pet-adoption'),
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.md),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => context.push(item.route),
            child: Container(
              width: 110,
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: item.bgColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: item.bgColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: item.color, size: 28),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: item.color,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
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

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String route;
  const _QuickAction(this.label, this.icon, this.color, this.bgColor, this.route);
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
