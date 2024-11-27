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

  /// Message indicating that the report is closed
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

  /// Option to show closed reports
  ///
  /// In en, this message translates to:
  /// **'show closed Reports'**
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
  /// **'DOC fix'**
  String get buildingReportSystem;

  /// Description of a report's low priority level
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get low;

  /// Description of a report's medium priority level
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get medium;

  /// Description of a report's high priority level
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get high;

  /// Description of a report's urgent priority level
  ///
  /// In en, this message translates to:
  /// **'urgent'**
  String get urgent;

  /// Description of a report's critical priority level
  ///
  /// In en, this message translates to:
  /// **'critical'**
  String get critical;

  /// Label for reporter role
  ///
  /// In en, this message translates to:
  /// **'reporter'**
  String get reporter;

  /// Label for operator role
  ///
  /// In en, this message translates to:
  /// **'operator'**
  String get operator;

  /// Label indicating the deadline for resolving an issue
  ///
  /// In en, this message translates to:
  /// **'resolve by'**
  String get resolveBy;

  /// Label for the selected area in the dropdown
  ///
  /// In en, this message translates to:
  /// **'selected area:'**
  String get selectedArea;

  /// Message shown when a user tries to complete a report assigned to the administrator
  ///
  /// In en, this message translates to:
  /// **'you can\'t complete the report if it\'s assigned to the administrator'**
  String get cannotCompleteReport;

  /// Message shown when a report fails to load
  ///
  /// In en, this message translates to:
  /// **'failed to load report'**
  String get failedToLoadReport;

  /// Label for the report category
  ///
  /// In en, this message translates to:
  /// **'category:'**
  String get category;

  /// Message indicating that the space is not usable
  ///
  /// In en, this message translates to:
  /// **'space not usable!!'**
  String get spaceNotUsable;

  /// Message shown when a report cannot be solved
  ///
  /// In en, this message translates to:
  /// **'report not solvable, contact the administrator!!'**
  String get reportNotSolvable;

  /// Message shown when a report is not found
  ///
  /// In en, this message translates to:
  /// **'report not found'**
  String get reportNotFound;

  /// Message shown when there is an error fetching areas
  ///
  /// In en, this message translates to:
  /// **'error loading areas'**
  String get errorLoadingAreas;

  /// Label prompting the user to select a category
  ///
  /// In en, this message translates to:
  /// **'select a category'**
  String get selectCategory;

  /// Dialog title asking for confirmation before deleting a report
  ///
  /// In en, this message translates to:
  /// **'confirm delete'**
  String get confirmDelete;

  /// Message asking for confirmation to delete a report
  ///
  /// In en, this message translates to:
  /// **'are you sure you want to delete this report?'**
  String get confirmDeleteReport;

  /// Label for the delete button
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// Dialog title asking for confirmation before assigning a report
  ///
  /// In en, this message translates to:
  /// **'confirm assignation'**
  String get confirmAssignation;

  /// Message asking for confirmation to assign a report
  ///
  /// In en, this message translates to:
  /// **'are you sure you want to assign this report to you?'**
  String get confirmAssignReport;

  /// Label for the assign button
  ///
  /// In en, this message translates to:
  /// **'assign'**
  String get assign;

  /// Dialog title asking for confirmation before unassigning a report
  ///
  /// In en, this message translates to:
  /// **'confirm unassignation'**
  String get confirmUnassignation;

  /// Message asking for confirmation to unassign a report
  ///
  /// In en, this message translates to:
  /// **'are you sure you want to unassign this report from you?'**
  String get confirmUnassignReport;

  /// Label for the unassign button
  ///
  /// In en, this message translates to:
  /// **'unassign'**
  String get unassign;

  /// Label indicating who the report is assigned to
  ///
  /// In en, this message translates to:
  /// **'assigned to:'**
  String get assignedTo;

  /// Message shown when there is an error fetching building areas
  ///
  /// In en, this message translates to:
  /// **'failed to load building areas'**
  String get failedToLoadBuildingAreas;

  /// Message shown when reports fail to load due to a false success flag
  ///
  /// In en, this message translates to:
  /// **'failed to load reports: success flag is false'**
  String get failedToLoadReportsSuccessFlag;

  /// Message shown when reports fail to load
  ///
  /// In en, this message translates to:
  /// **'failed to load reports'**
  String get failedToLoadReports;

  /// Message shown when there is an error creating a report
  ///
  /// In en, this message translates to:
  /// **'failed to create report'**
  String get failedToCreateReport;

  /// Message shown when there is an error deleting a report
  ///
  /// In en, this message translates to:
  /// **'failed to delete report'**
  String get failedToDeleteReport;

  /// Message shown when there is an error updating a report
  ///
  /// In en, this message translates to:
  /// **'failed to update report'**
  String get failedToUpdateReport;

  /// Label for the dropdown to select an operator
  ///
  /// In en, this message translates to:
  /// **'select operator'**
  String get selectOperator;

  /// Message shown when an operator must be selected before assigning
  ///
  /// In en, this message translates to:
  /// **'select an operator before assigning'**
  String get selectOperatorBeforeAssigning;

  /// Label for the field to enter the current password
  ///
  /// In en, this message translates to:
  /// **'old password'**
  String get oldPassword;

  /// Label for the field to re-enter the current password
  ///
  /// In en, this message translates to:
  /// **'repeat old password'**
  String get repeatOldPassword;

  /// Label for the field to enter a new password
  ///
  /// In en, this message translates to:
  /// **'new password'**
  String get newPassword;

  /// Button label to send a password reset link
  ///
  /// In en, this message translates to:
  /// **'send link'**
  String get sendLink;

  /// Button label to navigate to the password reset flow
  ///
  /// In en, this message translates to:
  /// **'forgot password?'**
  String get forgotPassword;
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
