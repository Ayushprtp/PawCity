import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_empty_state.dart';
import 'package:pawcity/shared/widgets/paw_error_state.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_skeleton.dart';

import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class CommunityFeedScreen extends ConsumerStatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  ConsumerState<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends ConsumerState<CommunityFeedScreen> with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _postsFuture;
  late AnimationController _fabController;
  String _sortBy = 'Trending'; // 'Trending' or 'Recent'
  String _filterCategory = 'All'; // 'All', 'General', 'Paw Patrol', 'Lost Pets', 'Adoption'

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fetchPosts();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _fetchPosts() {
    setState(() {
      var query = SupabaseService.client
          .from('community_posts')
          .select('*, profiles(display_name)');
      if (_filterCategory != 'All') {
        query = query.eq('category', _filterCategory);
      }
      if (_sortBy == 'Recent') {
        _postsFuture = query.order('created_at', ascending: false);
      } else {
        // Trending: order by likes descending, then recent
        _postsFuture = query.order('likes', ascending: false).order('created_at', ascending: false);
      }
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: context.colors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Text('Filter by Category', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.md),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: ['All', 'General', 'Paw Patrol', 'Lost Pets', 'Adoption'].map((cat) {
                  final isActive = _filterCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isActive,
                    selectedColor: context.colors.primaryContainer,
                    onSelected: (_) {
                      setState(() => _filterCategory = cat);
                      _fetchPosts();
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        );
      },
    );
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
      floatingActionButton: _buildRadialFab(),
      body: RefreshIndicator(
        onRefresh: () async => _fetchPosts(),
        child: ListView(
          children: [
            _hero(context),
            const SizedBox(height: AppSizes.sectionGap),
            Row(
              children: [
                GestureDetector(
                  onTap: () { setState(() => _sortBy = 'Trending'); _fetchPosts(); },
                  child: _tabChip(context, 'Trending', isActive: _sortBy == 'Trending'),
                ),
                const SizedBox(width: AppSizes.sm),
                GestureDetector(
                  onTap: () { setState(() => _sortBy = 'Recent'); _fetchPosts(); },
                  child: _tabChip(context, 'Recent', isActive: _sortBy == 'Recent'),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _showFilterSheet,
                  icon: const Icon(Icons.filter_list_rounded, size: 18),
                  label: Text(_filterCategory == 'All' ? 'Filter' : _filterCategory),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.lg),
                    itemBuilder: (_, __) => const PawPostCardSkeleton(),
                  );
                }

                if (snapshot.hasError) {
                  return PawErrorState(
                    icon: Icons.wifi_off_rounded,
                    title: 'Couldn\'t load posts',
                    message: 'Check your connection and try again.',
                    onRetry: _fetchPosts,
                  );
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const PawEmptyState(
                    icon: Icons.forum_outlined,
                    title: 'No posts yet',
                    message: 'Be the first to share something with the community!',
                    iconColor: context.colors.primary,
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

                    return _postCard(context, post, item);
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
                  color: context.colors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSizes.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: () => context.push('/new-post'),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('New Post'),
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
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

  Widget _buildRadialFab() {
    return AnimatedBuilder(
      animation: _fabController,
      builder: (context, child) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.bottomRight,
            clipBehavior: Clip.none,
            children: [
              if (_fabController.value > 0) ...[
                _buildCircularAction('New Post', Icons.edit_rounded, context.colors.primary, '/new-post', 0),
                _buildCircularAction('Paw Patrol', Icons.campaign_rounded, context.colors.error, '/paw-patrol', 1),
                _buildCircularAction('Lost Pets', Icons.search_rounded, context.colors.secondary, '/lost-pet', 2),
                _buildCircularAction('Adopt', Icons.volunteer_activism_rounded, context.colors.tertiary, '/pet-adoption', 3),
              ],
              Positioned(
                right: 0,
                bottom: 0,
                child: FloatingActionButton(
                  onPressed: () {
                    if (_fabController.isCompleted) {
                      _fabController.reverse();
                    } else {
                      _fabController.forward();
                    }
                  },
                  backgroundColor: context.colors.primary,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _fabController,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularAction(String label, IconData icon, Color color, String route, int index) {
    // We want to distribute 4 items along a 90-degree arc from top to left.
    // Angles: 90 degrees (pi/2) to 180 degrees (pi).
    // Bottom right is origin (0,0). Up is negative y, left is negative x.
    final double radius = 130.0;
    final double angle = (math.pi / 2) + (index * (math.pi / 2) / 3);
    
    final double x = radius * math.cos(angle) * _fabController.value;
    final double y = -radius * math.sin(angle) * _fabController.value;

    return Positioned(
      right: -x,
      bottom: -y,
      child: Transform.scale(
        scale: _fabController.value,
        child: Opacity(
          opacity: _fabController.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                 decoration: BoxDecoration(color: context.colors.surfaceContainerHigh, borderRadius: BorderRadius.circular(4)),
                 child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              FloatingActionButton.small(
                heroTag: route,
                onPressed: () {
                  _fabController.reverse();
                  context.push(route);
                },
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
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
        color: isActive ? context.colors.primaryContainer.withValues(alpha: 0.36) : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isActive ? context.colors.primary : context.colors.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            ),
      ),
    );
  }

  Widget _postCard(BuildContext context, _CommunityPost post, Map<String, dynamic> rawPost) {
    return PawAsymCard(
      onTap: () => context.push('/post-detail', extra: rawPost),
      child: GestureDetector(
        onDoubleTap: () async {
          // Double tap to like
          try {
            await SupabaseService.client.from('post_likes').insert({
              'post_id': rawPost['id'],
              'user_id': 'local_user'
            });
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Liked ❤️'), duration: Duration(seconds: 1)));
            }
          } catch (_) {
            // Might be already liked or error, ignore
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHigh,
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
          if (rawPost['image_url'] != null && rawPost['image_url'].toString().isNotEmpty) ...[
            const SizedBox(height: AppSizes.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: Image.network(rawPost['image_url'], fit: BoxFit.cover, width: double.infinity, height: 200),
            ),
          ] else if (post.mediaTag != null) ...[
            const SizedBox(height: AppSizes.md),
            Container(
              height: 176,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colors.surfaceContainerHigh,
                    context.colors.surfaceContainerLowest,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLg)),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(post.mediaIcon, color: context.colors.primary, size: 34),
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
      ),
    );
  }

  Widget _metricAction(BuildContext context, IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.colors.primary),
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
            color: context.colors.primary,
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
