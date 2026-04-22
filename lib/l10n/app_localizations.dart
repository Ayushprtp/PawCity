import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PawCity'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Discover. Explore. Wag.'**
  String get appTagline;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PawCity'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Discover pet-friendly places, trusted services, and a caring local community.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Care for Pets, Together'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Track pet health, share reviews, and keep your city safer for animals.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Report and Respond'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Use Paw Patrol to report urgent incidents and help nearby pets quickly.'**
  String get onboardingBody3;

  /// No description provided for @onboardingSpeciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Pet Family'**
  String get onboardingSpeciesTitle;

  /// No description provided for @onboardingSpeciesBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us what companions you care for so PawCity can personalize your feed.'**
  String get onboardingSpeciesBody;

  /// No description provided for @onboardingBasicInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Basic Details'**
  String get onboardingBasicInfoTitle;

  /// No description provided for @onboardingBasicInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Add your profile basics to unlock trusted local recommendations.'**
  String get onboardingBasicInfoBody;

  /// No description provided for @onboardingHealthActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Health & Activity Goals'**
  String get onboardingHealthActivityTitle;

  /// No description provided for @onboardingHealthActivityBody.
  ///
  /// In en, this message translates to:
  /// **'Share routines and wellness focus to get more relevant places and reminders.'**
  String get onboardingHealthActivityBody;

  /// No description provided for @onboardingPhotoUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a Profile Photo'**
  String get onboardingPhotoUploadTitle;

  /// No description provided for @onboardingPhotoUploadBody.
  ///
  /// In en, this message translates to:
  /// **'A friendly profile helps neighbors recognize and trust your reports and reviews.'**
  String get onboardingPhotoUploadBody;

  /// No description provided for @onboardingSpeciesDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get onboardingSpeciesDog;

  /// No description provided for @onboardingSpeciesCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get onboardingSpeciesCat;

  /// No description provided for @onboardingSpeciesBird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get onboardingSpeciesBird;

  /// No description provided for @onboardingSpeciesOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onboardingSpeciesOther;

  /// No description provided for @onboardingGoalDailyWalks.
  ///
  /// In en, this message translates to:
  /// **'Daily walks'**
  String get onboardingGoalDailyWalks;

  /// No description provided for @onboardingGoalWeightControl.
  ///
  /// In en, this message translates to:
  /// **'Weight control'**
  String get onboardingGoalWeightControl;

  /// No description provided for @onboardingGoalVetReminders.
  ///
  /// In en, this message translates to:
  /// **'Vet reminders'**
  String get onboardingGoalVetReminders;

  /// No description provided for @onboardingGoalSocialPlay.
  ///
  /// In en, this message translates to:
  /// **'Social play'**
  String get onboardingGoalSocialPlay;

  /// No description provided for @onboardingAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get onboardingAddPhoto;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish Setup'**
  String get onboardingFinish;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login now'**
  String get loginNow;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get registerNow;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @homePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'PawCity Home'**
  String get homePlaceholder;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get dashboardGreeting;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for your pet\'s next adventure?'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get dashboardNearby;

  /// No description provided for @dashboardCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community Updates'**
  String get dashboardCommunity;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @actionFindSpots.
  ///
  /// In en, this message translates to:
  /// **'Find Spots'**
  String get actionFindSpots;

  /// No description provided for @actionReport.
  ///
  /// In en, this message translates to:
  /// **'Paw Patrol'**
  String get actionReport;

  /// No description provided for @actionMyPets.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get actionMyPets;

  /// No description provided for @actionLostPet.
  ///
  /// In en, this message translates to:
  /// **'Lost Pet SOS'**
  String get actionLostPet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
