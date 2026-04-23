import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/router/route_names.dart';
import 'package:pawcity/features/auth/screens/login_screen.dart';
import 'package:pawcity/features/auth/screens/onboarding_screen.dart';
import 'package:pawcity/features/auth/screens/register_screen.dart';
import 'package:pawcity/features/auth/screens/splash_screen.dart';
import 'package:pawcity/features/home/screens/community_feed_screen.dart';
import 'package:pawcity/features/home/screens/community_post_detail_screen.dart';
import 'package:pawcity/features/home/screens/home_screen.dart';
import 'package:pawcity/features/home/screens/new_post_screen.dart';
import 'package:pawcity/features/lost_pet/screens/lost_pet_screen.dart';
import 'package:pawcity/features/lost_pet/screens/lost_pet_report_screen.dart';
import 'package:pawcity/features/map/screens/map_screen.dart';
import 'package:pawcity/features/notifications/screens/notifications_screen.dart';
import 'package:pawcity/features/paw_patrol/screens/paw_patrol_screen.dart';
import 'package:pawcity/features/paw_patrol/screens/report_detail_screen.dart';
import 'package:pawcity/features/paw_patrol/screens/report_map_screen.dart';
import 'package:pawcity/features/paw_patrol/screens/submit_report_screen.dart';
import 'package:pawcity/features/paws/screens/paws_explore_screen.dart';
import 'package:pawcity/features/pets/screens/medical_history_screen.dart';
import 'package:pawcity/features/pets/screens/my_pets_hub_screen.dart';
import 'package:pawcity/features/pets/screens/pet_adoption_screen.dart';
import 'package:pawcity/features/pets/screens/pet_profile_screen.dart';
import 'package:pawcity/features/pets/screens/add_pet_screen.dart';
import 'package:pawcity/features/profile/screens/profile_screen.dart';
import 'package:pawcity/features/reviews/screens/review_submitted_screen.dart';
import 'package:pawcity/features/reviews/screens/write_review_screen.dart';
import 'package:pawcity/features/shop/screens/checkout_screen.dart';
import 'package:pawcity/features/shop/screens/shop_new_arrivals_screen.dart';
import 'package:pawcity/features/shop/screens/shop_screen.dart';
import 'package:pawcity/features/shop/screens/shopping_cart_screen.dart';
import 'package:pawcity/features/spots/screens/booking_confirmation_screen.dart';
import 'package:pawcity/features/spots/screens/my_appointments_screen.dart';
import 'package:pawcity/features/spots/screens/services_grooming_screen.dart';
import 'package:pawcity/features/spots/screens/vet_booking_screen.dart';
import 'package:pawcity/features/spots/screens/veterinarian_profile_screen.dart';
import 'package:pawcity/providers/auth_provider.dart';
import 'package:pawcity/services/onboarding_service.dart';

/// Smooth fade + slide-up transition for all main routes.
CustomTransitionPage<void> _buildTransition(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

const _onboardingStepPaths = {
  '/onboarding/species',
  '/onboarding/basic-info',
  '/onboarding/health-activity',
  '/onboarding/photo-upload',
};

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      if (authState.isLoading) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      final publicRoutes = {
        '/splash',
        '/login',
        '/register',
      };
      final session = authState.valueOrNull;
      final signedIn = session != null;

      if (state.matchedLocation == '/splash') {
        return null;
      }

      if (!signedIn) {
        if (!publicRoutes.contains(state.matchedLocation)) {
          return '/login';
        }
        return null;
      }

      // Bypass Onboarding: If user is signed in, ensure they can go to home.
      if (publicRoutes.contains(state.matchedLocation) || state.matchedLocation == '/splash') {
        return '/home';
      }

      return null;
    },
    routes: [
      // Auth & Splash — instant transitions for snappy feel
      GoRoute(path: '/splash', name: RouteNames.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', name: RouteNames.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/onboarding/species', name: RouteNames.onboardingSpecies, builder: (_, __) => const OnboardingSpeciesScreen()),
      GoRoute(path: '/onboarding/basic-info', name: RouteNames.onboardingBasicInfo, builder: (_, __) => const OnboardingBasicInfoScreen()),
      GoRoute(path: '/onboarding/health-activity', name: RouteNames.onboardingHealthActivity, builder: (_, __) => const OnboardingHealthActivityScreen()),
      GoRoute(path: '/onboarding/photo-upload', name: RouteNames.onboardingPhotoUpload, builder: (_, __) => const OnboardingPhotoUploadScreen()),
      GoRoute(path: '/login', name: RouteNames.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', name: RouteNames.register, builder: (_, __) => const RegisterScreen()),

      // ─── Bottom Nav: Tab 0 — Home ───
      GoRoute(path: '/home', name: RouteNames.home, pageBuilder: (_, state) => _buildTransition(const HomeScreen(), state)),

      // ─── Bottom Nav: Tab 1 — Community ───
      GoRoute(path: '/community-feed', name: RouteNames.communityFeed, pageBuilder: (_, state) => _buildTransition(const CommunityFeedScreen(), state)),
      GoRoute(path: '/post-detail', builder: (context, state) {
        final post = state.extra as Map<String, dynamic>? ?? {};
        return CommunityPostDetailScreen(post: post);
      }),
      GoRoute(path: '/new-post', name: RouteNames.newPost, builder: (_, __) => const NewPostScreen()),

      // ─── Bottom Nav: Tab 2 — Paws Explore (Map) ───
      GoRoute(path: '/paws-explore', name: RouteNames.pawsExplore, pageBuilder: (_, state) => _buildTransition(const PawsExploreScreen(), state)),

      // ─── Bottom Nav: Tab 3 — Shop ───
      GoRoute(path: '/shop', name: RouteNames.shop, pageBuilder: (_, state) => _buildTransition(const ShopScreen(), state)),
      GoRoute(path: '/shop/new-arrivals', name: RouteNames.shopNewArrivals, builder: (_, __) => const ShopNewArrivalsScreen()),
      GoRoute(path: '/cart', name: RouteNames.cart, builder: (_, __) => const ShoppingCartScreen()),
      GoRoute(path: '/checkout', name: RouteNames.checkout, builder: (_, __) => const CheckoutScreen()),

      // ─── Bottom Nav: Tab 4 — My Pets Hub ───
      GoRoute(path: '/my-pets', name: RouteNames.myPets, pageBuilder: (_, state) => _buildTransition(const MyPetsHubScreen(), state)),

      // Sub-screens
      GoRoute(path: '/profile', name: RouteNames.profile, pageBuilder: (_, state) => _buildTransition(const ProfileScreen(), state)),
      GoRoute(path: '/notifications', name: RouteNames.notifications, pageBuilder: (_, state) => _buildTransition(const NotificationsScreen(), state)),

      // Paw Patrol
      GoRoute(path: '/paw-patrol', name: RouteNames.pawPatrol, builder: (_, __) => const PawPatrolScreen()),
      GoRoute(path: '/paw-patrol/report', name: RouteNames.pawPatrolReport, builder: (_, __) => const SubmitReportScreen()),
      GoRoute(path: '/paw-patrol/detail', name: RouteNames.pawPatrolDetail, builder: (_, __) => const ReportDetailScreen()),
      GoRoute(path: '/paw-patrol/map', name: RouteNames.pawPatrolMap, builder: (_, __) => const ReportMapScreen()),

      // Lost Pet
      GoRoute(path: '/lost-pet', name: RouteNames.lostPet, builder: (_, __) => const LostPetScreen()),
      GoRoute(path: '/lost-pet/report', name: RouteNames.lostPetReport, builder: (_, __) => const LostPetReportScreen()),

      // Map full-screen
      GoRoute(path: '/map', name: RouteNames.mapNearby, builder: (_, __) => const MapScreen()),

      // Spots & Appointments
      GoRoute(path: '/appointments', name: RouteNames.appointments, builder: (_, __) => const MyAppointmentsScreen()),
      GoRoute(path: '/vet-booking', name: RouteNames.vetBooking, builder: (_, __) => const VetBookingScreen()),
      GoRoute(path: '/veterinarian-profile', name: RouteNames.veterinarianProfile, builder: (_, __) => const VeterinarianProfileScreen()),
      GoRoute(path: '/booking-confirmation', name: RouteNames.bookingConfirmation, builder: (_, __) => const BookingConfirmationScreen()),
      GoRoute(path: '/services/grooming', name: RouteNames.servicesGrooming, builder: (_, __) => const ServicesGroomingScreen()),

      // Pets
      GoRoute(path: '/pet-profile', name: RouteNames.petProfile, builder: (_, __) => const PetProfileScreen()),
      GoRoute(path: '/add-pet', name: RouteNames.addPet, builder: (_, __) => const AddPetScreen()),
      GoRoute(path: '/medical-history', name: RouteNames.medicalHistory, builder: (context, state) {
        final petId = state.uri.queryParameters['petId'];
        return MedicalHistoryScreen(petId: petId);
      }),
      GoRoute(path: '/pet-adoption', name: RouteNames.petAdoption, builder: (_, __) => const PetAdoptionScreen()),

      // Reviews
      GoRoute(path: '/write-review', name: RouteNames.writeReview, builder: (_, __) => const WriteReviewScreen()),
      GoRoute(path: '/review-submitted', name: RouteNames.reviewSubmitted, builder: (_, __) => const ReviewSubmittedScreen()),
    ],
    errorBuilder: (context, state) => const LoginScreen(),
  );
});

final onboardingCompletedProvider = Provider<bool>((ref) {
  return ref.watch(onboardingStateProvider).valueOrNull ?? false;
});

final onboardingStateProvider = FutureProvider<bool>((ref) async {
  return OnboardingService.isCompleted();
});