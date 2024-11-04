import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// A message displayed when a general error occurs
  ///
  /// In en, this message translates to:
  /// **'an error occurred'**
  String get errorOccurred;

  /// Message indicating that a feature is not implemented
  ///
  /// In en, this message translates to:
  /// **'not implemented'**
  String get notImplemented;

  /// Error message for incorrect credentials
  ///
  /// In en, this message translates to:
  /// **'wrong credentials'**
  String get wrongCredentials;

  /// Error message when the user is not found
  ///
  /// In en, this message translates to:
  /// **'user not found'**
  String get userNotFound;

  /// Error message for an incorrect password
  ///
  /// In en, this message translates to:
  /// **'wrong password'**
  String get wrongPassword;

  /// Message asking the user to complete all fields
  ///
  /// In en, this message translates to:
  /// **'please complete all fields'**
  String get completeAllFields;

  /// Button label to add a report
  ///
  /// In en, this message translates to:
  /// **'add Report'**
  String get addReport;

  /// Message asking the user to provide details of the repair
  ///
  /// In en, this message translates to:
  /// **'please provide repair details'**
  String get provideRepairDetails;

  /// Label for the edit report screen
  ///
  /// In en, this message translates to:
  /// **'edit Report'**
  String get editReport;

  /// Label for the report title
  ///
  /// In en, this message translates to:
  /// **'title'**
  String get title;

  /// Label for the report description
  ///
  /// In en, this message translates to:
  /// **'description'**
  String get description;

  /// Label for the building name
  ///
  /// In en, this message translates to:
  /// **'building'**
  String get building;

  /// Label for the specific spot in the building
  ///
  /// In en, this message translates to:
  /// **'building Spot'**
  String get buildingSpot;

  /// Label for the report priority level
  ///
  /// In en, this message translates to:
  /// **'priority'**
  String get priority;

  /// Label for repair details
  ///
  /// In en, this message translates to:
  /// **'repair Description'**
  String get repairDescription;

  /// Label for photo gallery section
  ///
  /// In en, this message translates to:
  /// **'photo Gallery'**
  String get photoGallery;

  /// Label for the list of reports
  ///
  /// In en, this message translates to:
  /// **'report List'**
  String get reportList;

  /// Label for the user profile section
  ///
  /// In en, this message translates to:
  /// **'profile'**
  String get profile;

  /// Label for selecting a building
  ///
  /// In en, this message translates to:
  /// **'select Building'**
  String get selectBuilding;

  /// Label to select all buildings
  ///
  /// In en, this message translates to:
  /// **'all Buildings'**
  String get allBuildings;

  /// Instruction to swipe to complete a report
  ///
  /// In en, this message translates to:
  /// **'swipe to complete report:'**
  String get swipeToComplete;

  /// Message indicating that the report is completed
  ///
  /// In en, this message translates to:
  /// **'report status Completed'**
  String get reportStatusCompleted;

  /// Label for displaying date and time
  ///
  /// In en, this message translates to:
  /// **'datetime'**
  String get datetime;

  /// Label for the filter reports dialog
  ///
  /// In en, this message translates to:
  /// **'filter Reports'**
  String get filterReports;

  /// Option to show completed reports
  ///
  /// In en, this message translates to:
  /// **'show completed Reports'**
  String get showCompletedReports;

  /// Option to show deleted reports
  ///
  /// In en, this message translates to:
  /// **'show Deleted Reports'**
  String get showDeletedReports;

  /// Button label to clear the filters
  ///
  /// In en, this message translates to:
  /// **'clear'**
  String get clear;

  /// Button label to cancel an action
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// Button label to apply filters or changes
  ///
  /// In en, this message translates to:
  /// **'apply'**
  String get apply;

  /// Label for local report photos
  ///
  /// In en, this message translates to:
  /// **'local report photos'**
  String get localReportPhotos;

  /// Label for remote report photos
  ///
  /// In en, this message translates to:
  /// **'remote report photos'**
  String get remoteReportPhotos;

  /// Label for local repair photos
  ///
  /// In en, this message translates to:
  /// **'local repair photos'**
  String get localRepairPhotos;

  /// Label for remote repair photos
  ///
  /// In en, this message translates to:
  /// **'remote repair photos'**
  String get remoteRepairPhotos;

  /// Button label to add a photo
  ///
  /// In en, this message translates to:
  /// **'add Photo'**
  String get addPhoto;

  /// Label for selecting the priority level
  ///
  /// In en, this message translates to:
  /// **'select Priority'**
  String get selectPriority;

  /// Label for showing an error
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get error;

  /// App title for the Building Report System
  ///
  /// In en, this message translates to:
  /// **'building Report System'**
  String get buildingReportSystem;

  /// Description of a report's normal priority level
  ///
  /// In en, this message translates to:
  /// **'normal'**
  String get normal;

  /// Description of a report's urgent priority level
  ///
  /// In en, this message translates to:
  /// **'urgent'**
  String get urgent;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
