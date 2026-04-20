import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/router/route_names.dart';
import 'package:pawcity/features/auth/screens/login_screen.dart';
import 'package:pawcity/features/auth/screens/onboarding_screen.dart';
import 'package:pawcity/features/auth/screens/register_screen.dart';
import 'package:pawcity/features/auth/screens/splash_screen.dart';
import 'package:pawcity/features/home/screens/community_feed_screen.dart';
import 'package:pawcity/features/home/screens/home_screen.dart';
import 'package:pawcity/features/paw_patrol/screens/paw_patrol_screen.dart';
import 'package:pawcity/features/paw_patrol/screens/report_detail_screen.dart';
import 'package:pawcity/features/paw_patrol/screens/report_map_screen.dart';
import 'package:pawcity/features/paw_patrol/screens/submit_report_screen.dart';
import 'package:pawcity/features/pets/screens/medical_history_screen.dart';
import 'package:pawcity/features/pets/screens/pet_adoption_screen.dart';
import 'package:pawcity/features/pets/screens/pet_profile_screen.dart';
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
        '/onboarding',
        ..._onboardingStepPaths,
      };
      final session = authState.valueOrNull;
      final signedIn = session != null;

      if (state.matchedLocation == '/splash') {
        return null;
      }

      final onboardingCompleted = ref.read(onboardingCompletedProvider);
      final onOnboardingStep = _onboardingStepPaths.contains(state.matchedLocation);
      if (!onboardingCompleted && !onOnboardingStep) {
        return '/onboarding/species';
      }

      if (!signedIn && !publicRoutes.contains(state.matchedLocation)) {
        return '/login';
      }

      if (signedIn &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/register' ||
              _onboardingStepPaths.contains(state.matchedLocation))) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/onboarding/species',
        name: RouteNames.onboardingSpecies,
        builder: (context, state) => const OnboardingSpeciesScreen(),
      ),
      GoRoute(
        path: '/onboarding/basic-info',
        name: RouteNames.onboardingBasicInfo,
        builder: (context, state) => const OnboardingBasicInfoScreen(),
      ),
      GoRoute(
        path: '/onboarding/health-activity',
        name: RouteNames.onboardingHealthActivity,
        builder: (context, state) => const OnboardingHealthActivityScreen(),
      ),
      GoRoute(
        path: '/onboarding/photo-upload',
        name: RouteNames.onboardingPhotoUpload,
        builder: (context, state) => const OnboardingPhotoUploadScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/community-feed',
        name: RouteNames.communityFeed,
        builder: (context, state) => const CommunityFeedScreen(),
      ),
      GoRoute(
        path: '/paw-patrol',
        name: RouteNames.pawPatrol,
        builder: (context, state) => const PawPatrolScreen(),
      ),
      GoRoute(
        path: '/paw-patrol/report',
        name: RouteNames.pawPatrolReport,
        builder: (context, state) => const SubmitReportScreen(),
      ),
      GoRoute(
        path: '/paw-patrol/detail',
        name: RouteNames.pawPatrolDetail,
        builder: (context, state) => const ReportDetailScreen(),
      ),
      GoRoute(
        path: '/paw-patrol/map',
        name: RouteNames.pawPatrolMap,
        builder: (context, state) => const ReportMapScreen(),
      ),
      GoRoute(
        path: '/shop',
        name: RouteNames.shop,
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: '/shop/new-arrivals',
        name: RouteNames.shopNewArrivals,
        builder: (context, state) => const ShopNewArrivalsScreen(),
      ),
      GoRoute(
        path: '/cart',
        name: RouteNames.cart,
        builder: (context, state) => const ShoppingCartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        name: RouteNames.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/appointments',
        name: RouteNames.appointments,
        builder: (context, state) => const MyAppointmentsScreen(),
      ),
      GoRoute(
        path: '/vet-booking',
        name: RouteNames.vetBooking,
        builder: (context, state) => const VetBookingScreen(),
      ),
      GoRoute(
        path: '/veterinarian-profile',
        name: RouteNames.veterinarianProfile,
        builder: (context, state) => const VeterinarianProfileScreen(),
      ),
      GoRoute(
        path: '/booking-confirmation',
        name: RouteNames.bookingConfirmation,
        builder: (context, state) => const BookingConfirmationScreen(),
      ),
      GoRoute(
        path: '/services/grooming',
        name: RouteNames.servicesGrooming,
        builder: (context, state) => const ServicesGroomingScreen(),
      ),
      GoRoute(
        path: '/pet-profile',
        name: RouteNames.petProfile,
        builder: (context, state) => const PetProfileScreen(),
      ),
      GoRoute(
        path: '/medical-history',
        name: RouteNames.medicalHistory,
        builder: (context, state) => const MedicalHistoryScreen(),
      ),
      GoRoute(
        path: '/pet-adoption',
        name: RouteNames.petAdoption,
        builder: (context, state) => const PetAdoptionScreen(),
      ),
      GoRoute(
        path: '/write-review',
        name: RouteNames.writeReview,
        builder: (context, state) => const WriteReviewScreen(),
      ),
      GoRoute(
        path: '/review-submitted',
        name: RouteNames.reviewSubmitted,
        builder: (context, state) => const ReviewSubmittedScreen(),
      ),
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