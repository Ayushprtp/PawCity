import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _captionController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'General';
  bool _isPosting = false;

  @override
  void dispose() {
    _captionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isPosting = true);

    try {
      await SupabaseService.client.from('community_posts').insert({
        'author_name': 'Me',
        'message': content, // the DB expects message
        'category': _selectedCategory,
        'media_tag': _captionController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post published!')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'New Post',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
              ),
              items: const [
                DropdownMenuItem(value: 'General', child: Text('General')),
                DropdownMenuItem(value: 'Paw Patrol', child: Text('Paw Patrol')),
                DropdownMenuItem(value: 'Lost Pets', child: Text('Lost Pets')),
                DropdownMenuItem(value: 'Adoption', child: Text('Adoption')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                labelText: 'Caption / Title (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                filled: true,
                fillColor: context.colors.surfaceContainerLow,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.image),
                  label: const Text('Add Photo'),
                ),
                const SizedBox(width: AppSizes.sm),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.videocam),
                  label: const Text('Add Video'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            PawGradientButton(
              label: 'Post',
              isLoading: _isPosting,
              onPressed: _submitPost,
            ),
          ],
        ),
      ),
    );
  }
}
