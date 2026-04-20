import 'package:posthog_flutter/posthog_flutter.dart';

class PostHogEvents {
  static const onboardingCompletedEvent = 'onboarding_completed';
  static const onboardingStepViewed = 'onboarding_step_viewed';
  static const onboardingStepContinued = 'onboarding_step_continued';
  static const onboardingSkipped = 'onboarding_skipped';
  static const userSignedUp = 'user_signed_up';
  static const userLoggedIn = 'user_logged_in';
  static const spotViewed = 'spot_viewed';
  static const spotSearched = 'spot_searched';
  static const spotSubmitted = 'spot_submitted';
  static const spotFilterApplied = 'spot_filter_applied';
  static const spotFavorited = 'spot_favorited';
  static const routePlanned = 'route_planned';
  static const reviewSubmitted = 'review_submitted';
  static const reviewPhotoAdded = 'review_photo_added';
  static const petProfileCreated = 'pet_profile_created';
  static const petQrGenerated = 'pet_qr_generated';
  static const healthRecordAdded = 'health_record_added';
  static const qrScanned = 'qr_scanned';
  static const reportSubmitted = 'paw_patrol_report_submitted';
  static const reportViewed = 'paw_patrol_report_viewed';
  static const reportUpvoted = 'paw_patrol_report_upvoted';
  static const reportShared = 'paw_patrol_report_shared';
  static const authorityTagged = 'authority_tagged';
  static const mediaUploadedToReport = 'media_uploaded';
  static const lostPetAlertPosted = 'lost_pet_alert_posted';
  static const lostPetAlertViewed = 'lost_pet_alert_viewed';
  static const lostPetFoundMarked = 'lost_pet_found_marked';
  static const pawPointsEarned = 'paw_points_earned';
  static const badgeUnlocked = 'badge_unlocked';
  static const checkInRecorded = 'check_in_recorded';
}

class PostHogService {
  PostHogService._();

  static Future<void> track(
    String event, {
    Map<String, Object> properties = const {},
  }) async {
    Posthog().capture(eventName: event, properties: properties);
  }
}
