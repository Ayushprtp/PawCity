import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/providers/auth_provider.dart';
import 'package:pawcity/providers/pet_provider.dart';
import 'package:pawcity/providers/profile_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final petsAsync = ref.watch(userPetsProvider);

    return PawScaffold(
      title: 'My Profile',
      currentNavIndex: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () => context.go('/settings'),
        ),
      ],
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load profile')),
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_off_rounded, size: 64,
                      color: AppColors.outlineVariant),
                  const SizedBox(height: AppSizes.lg),
                  Text('Sign in to view your profile',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSizes.sectionGap),
                  PawGradientButton(
                    label: 'Sign In',
                    onPressed: () => context.go('/login'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Profile Card
                _buildHeroCard(context, profile),
                const SizedBox(height: AppSizes.sectionGap),

                // Stats Row
                _buildStatsRow(context, profile, petsAsync),
                const SizedBox(height: AppSizes.sectionGap),

                // Bio Section
                if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                  Text('About',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                  const SizedBox(height: AppSizes.sm),
                  PawAsymCard(
                    child: Text(profile.bio!,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const SizedBox(height: AppSizes.sectionGap),
                ],

                // My Pets Section
                Text('My Pets',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                const SizedBox(height: AppSizes.md),
                petsAsync.when(
                  loading: () => const Center(
                      child: Padding(
                    padding: EdgeInsets.all(AppSizes.xl),
                    child: CircularProgressIndicator(),
                  )),
                  error: (_, __) =>
                      const PawAsymCard(child: Text('Unable to load pets')),
                  data: (pets) {
                    if (pets.isEmpty) {
                      return PawAsymCard(
                        child: Column(
                          children: [
                            const Icon(Icons.pets_rounded,
                                size: 48, color: AppColors.outlineVariant),
                            const SizedBox(height: AppSizes.md),
                            Text('No pets added yet',
                                style:
                                    Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: AppSizes.md),
                            PawGradientButton(
                              label: 'Add Your First Pet',
                              onPressed: () => context.go('/add-pet'),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: pets.map((pet) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSizes.md),
                          child: PawAsymCard(
                            onTap: () =>
                                context.go('/pet-profile?id=${pet.id}'),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: AppGradients.softSurface,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.radiusMd),
                                  ),
                                  child: pet.photoUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  AppSizes.radiusMd),
                                          child: Image.network(
                                              pet.photoUrl!,
                                              fit: BoxFit.cover),
                                        )
                                      : Center(
                                          child: Text(
                                            pet.type.emoji,
                                            style: const TextStyle(
                                                fontSize: 28),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: AppSizes.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(pet.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.w700)),
                                      const SizedBox(height: AppSizes.xs),
                                      Text(
                                        [
                                          pet.breed ?? pet.type.label,
                                          if (pet.gender != null)
                                            pet.gender!,
                                          if (pet.weightKg != null)
                                            '${pet.weightKg} kg',
                                        ].join(' · '),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: AppColors
                                                    .onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded,
                                    color: AppColors.outlineVariant),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: AppSizes.sectionGap),

                // Quick Actions
                Text('Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                const SizedBox(height: AppSizes.md),
                _buildActionTile(context, Icons.favorite_rounded,
                    'My Favorites', AppColors.primary, () {}),
                const SizedBox(height: AppSizes.sm),
                _buildActionTile(context, Icons.rate_review_rounded,
                    'My Reviews', AppColors.secondary, () => context.go('/write-review')),
                const SizedBox(height: AppSizes.sm),
                _buildActionTile(context, Icons.campaign_rounded,
                    'My Reports', AppColors.tertiary, () => context.go('/paw-patrol')),
                const SizedBox(height: AppSizes.sectionGap),

                // Sign Out
                PawGradientButton(
                  label: 'Sign Out',
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    await authService.signOut();
                    if (context.mounted) context.go('/login');
                  },
                ),
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: AppGradients.dashboardHero,
        borderRadius: AppEffects.asymCardRadius,
        boxShadow: AppEffects.softShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white24,
            backgroundImage: profile.avatarUrl != null
                ? NetworkImage(profile.avatarUrl!)
                : null,
            child: profile.avatarUrl == null
                ? Text(
                    (profile.displayName ?? profile.username)[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  )
                : null,
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName ?? profile.username,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  '@${profile.username}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                if (profile.city != null) ...[
                  const SizedBox(height: AppSizes.xs),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: Colors.white60),
                      const SizedBox(width: AppSizes.xs),
                      Text(profile.city!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white60)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
      BuildContext context, dynamic profile, AsyncValue<dynamic> petsAsync) {
    final petCount = petsAsync.valueOrNull?.length ?? 0;
    return Row(
      children: [
        _statCard(context, '${profile.pawPoints}', 'Paw Points',
            Icons.star_rounded, AppColors.tertiaryContainer),
        const SizedBox(width: AppSizes.md),
        _statCard(context, '$petCount', 'Pets', Icons.pets_rounded,
            AppColors.primaryContainer),
        const SizedBox(width: AppSizes.md),
        _statCard(context, profile.isNgo ? 'NGO' : 'Member', 'Role',
            Icons.verified_user_rounded, AppColors.secondaryContainer),
      ],
    );
  }

  Widget _statCard(BuildContext context, String value, String label,
      IconData icon, Color bgColor) {
    return Expanded(
      child: PawAsymCard(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(icon, size: 20, color: AppColors.onSurface),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String label,
      Color color, VoidCallback onTap) {
    return PawAsymCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Text(label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.outlineVariant),
        ],
      ),
    );
  }
}
