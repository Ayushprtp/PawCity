import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/providers/auth_provider.dart';
import 'package:pawcity/providers/pet_provider.dart';
import 'package:pawcity/providers/profile_provider.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_empty_state.dart';
import 'package:pawcity/shared/widgets/paw_error_state.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_skeleton.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class MyPetsHubScreen extends ConsumerStatefulWidget {
  const MyPetsHubScreen({super.key});
  @override
  ConsumerState<MyPetsHubScreen> createState() => _MyPetsHubScreenState();
}

class _MyPetsHubScreenState extends ConsumerState<MyPetsHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabC;

  @override
  void initState() {
    super.initState();
    _tabC = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'My Pets',
      currentNavIndex: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_rounded),
          onPressed: () => context.push('/add-pet'),
          tooltip: 'Add Pet',
        ),
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () => context.push('/profile'),
          tooltip: 'Profile',
        ),
      ],
      body: TabBarView(
        controller: _tabC,
        children: [
          _petsTab(),
          _appointmentsTab(),
          _profileTab(),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          controller: _tabC,
          labelColor: context.colors.primary,
          unselectedLabelColor: context.colors.onSurfaceVariant,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3,
              color: context.colors.primary,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
          ),
          tabs: const [
            Tab(text: 'Pets'),
            Tab(text: 'Appointments'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
    );
  }

  // ─── PETS TAB ───
  Widget _petsTab() {
    final petsAsync = ref.watch(userPetsProvider);
    return petsAsync.when(
      loading: () => ListView.separated(
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.lg),
        itemBuilder: (_, __) => const PawPetCardSkeleton(),
      ),
      error: (_, __) => PawErrorState(
        icon: Icons.pets_rounded,
        title: 'Couldn\'t load pets',
        message: 'Pull down to refresh or tap to retry.',
        onRetry: () => ref.invalidate(userPetsProvider),
      ),
      data: (pets) {
        if (pets.isEmpty) {
          return PawEmptyState(
            icon: Icons.pets_rounded,
            title: 'No pets yet',
            message: 'Add your first furry friend!',
            actionLabel: 'Add Pet',
            onAction: () => context.push('/add-pet'),
            iconColor: context.colors.primary,
          );
        }
        return ListView.separated(
          itemCount: pets.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.lg),
          itemBuilder: (_, i) {
            final pet = pets[i];
            return PawAsymCard(
              onTap: () =>
                  context.push('/medical-history?petId=${pet.id}'),
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: AppGradients.dashboardHero,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.radiusLg),
                        topRight: Radius.circular(AppSizes.radiusXl),
                      ),
                    ),
                    child: pet.photoUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft:
                                  Radius.circular(AppSizes.radiusLg),
                              topRight:
                                  Radius.circular(AppSizes.radiusXl),
                            ),
                            child: Image.network(pet.photoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                    child: Text(pet.type.emoji,
                                        style: const TextStyle(
                                            fontSize: 48)))))
                        : Center(
                            child: Text(pet.type.emoji,
                                style:
                                    const TextStyle(fontSize: 48))),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.all(AppSizes.cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(pet.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontWeight:
                                              FontWeight.w800)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.md,
                                  vertical: AppSizes.xs),
                              decoration: BoxDecoration(
                                color: context.colors.primaryContainer
                                    .withValues(alpha: 0.3),
                                borderRadius:
                                    BorderRadius.circular(
                                        AppSizes.radiusFull),
                              ),
                              child: Text(pet.type.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: context.colors.primary,
                                        fontWeight: FontWeight.w700,
                                      )),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Wrap(
                          spacing: AppSizes.sm,
                          runSpacing: AppSizes.sm,
                          children: [
                            if (pet.breed != null)
                              _infoChip(Icons.category_rounded,
                                  pet.breed!),
                            if (pet.gender != null)
                              _infoChip(Icons.male_rounded,
                                  pet.gender!),
                            if (pet.weightKg != null)
                              _infoChip(
                                  Icons.monitor_weight_rounded,
                                  '${pet.weightKg} kg'),
                          ],
                        ),
                        const SizedBox(height: AppSizes.md),
                        Row(
                          children: [
                            _actionBtn(
                                Icons.medical_services_rounded,
                                'Health',
                                context.colors.vet,
                                () => context.push(
                                    '/medical-history?petId=${pet.id}')),
                            const SizedBox(width: AppSizes.sm),
                            _actionBtn(
                                Icons.auto_awesome_rounded,
                                'Activity',
                                context.colors.primary,
                                () => context.push(
                                    '/activity-explorer?petId=${pet.id}',
                                    extra: pet)),
                            const SizedBox(width: AppSizes.sm),
                            _actionBtn(
                                Icons.edit_rounded,
                                'Edit',
                                context.colors.secondary,
                                () {}),
                            const SizedBox(width: AppSizes.sm),
                            _actionBtn(
                                Icons.qr_code_rounded,
                                'QR',
                                context.colors.tertiary,
                                () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── APPOINTMENTS TAB ───
  Widget _appointmentsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.separated(
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
            itemBuilder: (_, __) => const PawRowSkeleton(),
          );
        }

        final appointments = snapshot.data ?? [];

        if (appointments.isEmpty) {
          return PawEmptyState(
            icon: Icons.event_note_rounded,
            title: 'No appointments yet',
            message: 'Book a vet visit or grooming session',
            actionLabel: 'Book Now',
            onAction: () => context.push('/vet-booking'),
            iconColor: context.colors.secondary,
          );
        }

        return ListView.separated(
          itemCount: appointments.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
          itemBuilder: (_, i) {
            final appt = appointments[i];
            return _appointmentCard(appt);
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) return [];
      return await SupabaseService.client
          .from('appointments')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: true);
    } catch (_) {
      return [];
    }
  }

  Widget _appointmentCard(Map<String, dynamic> appt) {
    final status = appt['status']?.toString() ?? 'upcoming';
    final statusColor = switch (status) {
      'upcoming' => context.colors.vet,
      'completed' => context.colors.park,
      'cancelled' => context.colors.error,
      _ => context.colors.onSurfaceVariant,
    };

    return PawAsymCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(
              switch (appt['service_type']?.toString()) {
                'vet' => Icons.local_hospital_rounded,
                'grooming' => Icons.content_cut_rounded,
                'vaccination' => Icons.vaccines_rounded,
                _ => Icons.event_rounded,
              },
              color: statusColor,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appt['title']?.toString() ?? 'Appointment',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  appt['date']?.toString() ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm, vertical: AppSizes.xs),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              status[0].toUpperCase() + status.substring(1),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROFILE TAB ───
  Widget _profileTab() {
    final profileAsync = ref.watch(currentProfileProvider);
    return profileAsync.when(
      loading: () => const PawProfileSkeleton(),
      error: (_, __) => PawErrorState(
        icon: Icons.person_off_rounded,
        title: 'Unable to load profile',
        message: 'Something went wrong. Please try again.',
        onRetry: () => ref.invalidate(currentProfileProvider),
      ),
      data: (profile) {
        if (profile == null) {
          return PawEmptyState(
            icon: Icons.person_off_rounded,
            title: 'Sign in to view your profile',
            actionLabel: 'Sign In',
            onAction: () => context.go('/login'),
            iconColor: context.colors.outlineVariant,
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile hero card
              Container(
                padding: const EdgeInsets.all(AppSizes.xl),
                decoration: BoxDecoration(
                  gradient: AppGradients.dashboardHero,
                  borderRadius: AppEffects.asymCardRadius,
                  boxShadow: AppEffects.softShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white24,
                      backgroundImage: profile.avatarUrl != null
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child: profile.avatarUrl == null
                          ? Text(
                              (profile.displayName ?? profile.username)[0]
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 24,
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
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text('@${profile.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white70)),
                          if (profile.city != null) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    size: 12, color: Colors.white60),
                                const SizedBox(width: 4),
                                Text(profile.city!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Colors.white60)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Stats
              Row(
                children: [
                  _statChip('${profile.pawPoints}', 'Paw Points',
                      Icons.star_rounded, context.colors.tertiaryContainer),
                  const SizedBox(width: AppSizes.sm),
                  _statChip(
                      profile.isNgo ? 'NGO' : 'Member',
                      'Role',
                      Icons.verified_user_rounded,
                      context.colors.secondaryContainer),
                ],
              ),
              const SizedBox(height: AppSizes.lg),

              // Quick Actions
              _actionTile(Icons.favorite_rounded, 'My Favorites',
                  context.colors.primary, () {}),
              const SizedBox(height: AppSizes.sm),
              _actionTile(Icons.rate_review_rounded, 'My Reviews',
                  context.colors.secondary, () => context.push('/write-review')),
              const SizedBox(height: AppSizes.sm),
              _actionTile(Icons.campaign_rounded, 'Paw Patrol Reports',
                  context.colors.tertiary, () => context.push('/paw-patrol')),
              const SizedBox(height: AppSizes.sm),
              _actionTile(Icons.warning_amber_rounded, 'Lost Pet SOS',
                  context.colors.error, () => context.push('/lost-pet')),
              const SizedBox(height: AppSizes.sectionGap),

              // Sign Out
              PawGradientButton(
                label: 'Sign Out',
                onPressed: () async {
                  final authService = ref.read(authServiceProvider);
                  await authService.signOut();
                  if (!mounted) return;
                  context.go('/login');
                },
              ),
              const SizedBox(height: AppSizes.xxl),
            ],
          ),
        );
      },
    );
  }

  // ─── Helpers ───
  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.colors.onSurfaceVariant),
          const SizedBox(width: AppSizes.xs),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: context.colors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _actionBtn(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: AppSizes.xs),
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                          color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(
      String value, String label, IconData icon, Color bgColor) {
    return Expanded(
      child: PawAsymCard(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(icon, size: 18, color: context.colors.onSurface),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text(label,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: context.colors.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(
      IconData icon, String label, Color color, VoidCallback onTap) {
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
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Icon(Icons.chevron_right_rounded,
              color: context.colors.outlineVariant),
        ],
      ),
    );
  }
}
