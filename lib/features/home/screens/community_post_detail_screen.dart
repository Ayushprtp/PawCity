import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class CommunityPostDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> post;
  const CommunityPostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<CommunityPostDetailScreen> createState() => _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends ConsumerState<CommunityPostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _commentsFuture;
  late int _likes;
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _likes = widget.post['likes'] as int? ?? 0;
    _isLiked = false; // We would fetch user specific like status ideally
    _fetchComments();
  }

  void _fetchComments() {
    setState(() {
      _commentsFuture = SupabaseService.client
          .from('community_comments')
          .select('*, profiles(display_name)')
          .eq('post_id', widget.post['id'])
          .order('created_at', ascending: true);
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
    // In a real app we would update the backend here.
  }

  void _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    try {
      // In a real scenario, ensure user is authenticated
      await SupabaseService.client.from('community_comments').insert({
        'post_id': widget.post['id'],
        'author_id': SupabaseService.client.auth.currentUser?.id ?? 'dummy_author',
        'message': text,
      });
      _commentController.clear();
      _fetchComments();
      if (!mounted) return;
      FocusScope.of(context).unfocus();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting comment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.post['profiles'] as Map<String, dynamic>?;
    final author = profile?['display_name'] ?? 'Anonymous';
    final message = widget.post['message']?.toString() ?? '';

    return PawScaffold(
      title: 'Post',
      showBackButton: true,
      showBottomNav: false,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                _buildPostContent(author, message),
                const Divider(height: AppSizes.xxl),
                Text(
                  'Comments',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSizes.md),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _commentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Text('Failed to load comments');
                    }
                    final comments = snapshot.data ?? [];
                    if (comments.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(AppSizes.xl),
                        child: Text(
                          'No comments yet. Be the first to reply!',
                          style: TextStyle(color: context.colors.onSurfaceVariant),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
                      itemBuilder: (context, index) {
                        final c = comments[index];
                        final cProfile = c['profiles'] as Map<String, dynamic>?;
                        final cAuthor = cProfile?['display_name'] ?? 'Anonymous';
                        return _buildCommentTile(cAuthor, c['message'].toString());
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostContent(String author, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: context.colors.surfaceContainerHigh,
              child: Text(
                author.characters.take(2).join(),
                style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Text(
              author,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSizes.lg),
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isLiked ? context.colors.error : context.colors.primary,
              ),
              onPressed: _toggleLike,
            ),
            Text('$_likes', style: const TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.share_rounded, color: context.colors.primary),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentTile(String author, String message) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: AppEffects.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSizes.xs),
          Text(message),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: context.colors.surfaceContainerLowest,
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            IconButton(
              icon: Icon(Icons.send_rounded, color: context.colors.primary),
              onPressed: _postComment,
            ),
          ],
        ),
      ),
    );
  }
}
