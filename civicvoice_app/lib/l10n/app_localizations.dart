import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CivicVoice'**
  String get appTitle;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'100% Anonymous'**
  String get anonymous;

  /// No description provided for @anonymousDescription.
  ///
  /// In en, this message translates to:
  /// **'Report governance issues safely without revealing your identity. Your privacy is our priority.'**
  String get anonymousDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report Submitted!'**
  String get reportSubmitted;

  /// No description provided for @reportSubmittedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your report has been submitted anonymously'**
  String get reportSubmittedDescription;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @returnHome.
  ///
  /// In en, this message translates to:
  /// **'Return Home'**
  String get returnHome;

  /// No description provided for @trackReport.
  ///
  /// In en, this message translates to:
  /// **'Track Report'**
  String get trackReport;

  /// No description provided for @checkStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get checkStatus;

  /// No description provided for @moderatorAccess.
  ///
  /// In en, this message translates to:
  /// **'Moderator Access'**
  String get moderatorAccess;

  /// No description provided for @loginSecurely.
  ///
  /// In en, this message translates to:
  /// **'Login Securely'**
  String get loginSecurely;

  /// No description provided for @publicDashboard.
  ///
  /// In en, this message translates to:
  /// **'Public Dashboard'**
  String get publicDashboard;

  /// No description provided for @requestDataPackage.
  ///
  /// In en, this message translates to:
  /// **'Request Data Package'**
  String get requestDataPackage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Title'**
  String get reportTitle;

  /// No description provided for @briefTitle.
  ///
  /// In en, this message translates to:
  /// **'Brief, clear title of the issue'**
  String get briefTitle;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select issue category'**
  String get selectCategory;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search for a city'**
  String get searchCity;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @detailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Provide detailed information about the issue...'**
  String get detailedInfo;

  /// No description provided for @addAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add Attachment'**
  String get addAttachment;

  /// No description provided for @addAttachmentOptional.
  ///
  /// In en, this message translates to:
  /// **'Add Attachment (Optional)'**
  String get addAttachmentOptional;

  /// No description provided for @attachmentTypes.
  ///
  /// In en, this message translates to:
  /// **'Photos, documents, or other evidence'**
  String get attachmentTypes;

  /// No description provided for @submitAnonymously.
  ///
  /// In en, this message translates to:
  /// **'Submit Anonymously'**
  String get submitAnonymously;

  /// No description provided for @privacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Your report is completely anonymous. We do not collect any personal information that could identify you.'**
  String get privacyNotice;

  /// No description provided for @helpPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Help & Privacy'**
  String get helpPrivacy;

  /// No description provided for @completeAnonymity.
  ///
  /// In en, this message translates to:
  /// **'Complete Anonymity'**
  String get completeAnonymity;

  /// No description provided for @anonymityDescription.
  ///
  /// In en, this message translates to:
  /// **'Your personal information is never collected or stored. Reports cannot be traced back to you.'**
  String get anonymityDescription;

  /// No description provided for @whatToInclude.
  ///
  /// In en, this message translates to:
  /// **'What to Include'**
  String get whatToInclude;

  /// No description provided for @includeDescription.
  ///
  /// In en, this message translates to:
  /// **'• Clear, factual description\n• Specific location\n• Supporting documents if available\n• Date and time when possible'**
  String get includeDescription;

  /// No description provided for @reportProcess.
  ///
  /// In en, this message translates to:
  /// **'Report Process'**
  String get reportProcess;

  /// No description provided for @processDescription.
  ///
  /// In en, this message translates to:
  /// **'Reports are reviewed by verified moderators and may be published on the public dashboard after verification.'**
  String get processDescription;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @submitReportAction.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReportAction;

  /// No description provided for @trackStatusAction.
  ///
  /// In en, this message translates to:
  /// **'Track Status'**
  String get trackStatusAction;

  /// No description provided for @browseReports.
  ///
  /// In en, this message translates to:
  /// **'Browse Reports'**
  String get browseReports;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appSettings;

  /// No description provided for @recentReports.
  ///
  /// In en, this message translates to:
  /// **'Recent Reports'**
  String get recentReports;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @platformStatistics.
  ///
  /// In en, this message translates to:
  /// **'Platform Statistics'**
  String get platformStatistics;

  /// No description provided for @totalReports.
  ///
  /// In en, this message translates to:
  /// **'Total Reports'**
  String get totalReports;

  /// No description provided for @allSubmissions.
  ///
  /// In en, this message translates to:
  /// **'All submissions'**
  String get allSubmissions;

  /// No description provided for @recentReportsCount.
  ///
  /// In en, this message translates to:
  /// **'Recent Reports'**
  String get recentReportsCount;

  /// No description provided for @lastVerified.
  ///
  /// In en, this message translates to:
  /// **'Last 3 verified'**
  String get lastVerified;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {userName}!'**
  String welcomeBack(Object userName);

  /// No description provided for @makeDifference.
  ///
  /// In en, this message translates to:
  /// **'Ready to make a difference today?'**
  String get makeDifference;

  /// No description provided for @welcomeGuest.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CivicVoice!'**
  String get welcomeGuest;

  /// No description provided for @browseSubmit.
  ///
  /// In en, this message translates to:
  /// **'Browse reports or submit anonymously'**
  String get browseSubmit;

  /// No description provided for @registerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Register as a researcher or moderator to access advanced features'**
  String get registerPrompt;

  /// No description provided for @privacyProtected.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is protected with end-to-end encryption'**
  String get privacyProtected;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @requestResearchData.
  ///
  /// In en, this message translates to:
  /// **'Request Research Data'**
  String get requestResearchData;

  /// No description provided for @purchaseDescription.
  ///
  /// In en, this message translates to:
  /// **'Purchase anonymized governance report data for research purposes.'**
  String get purchaseDescription;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @researchInstitution.
  ///
  /// In en, this message translates to:
  /// **'Your research institution or organization'**
  String get researchInstitution;

  /// No description provided for @researchPurpose.
  ///
  /// In en, this message translates to:
  /// **'Research Purpose'**
  String get researchPurpose;

  /// No description provided for @explainUsage.
  ///
  /// In en, this message translates to:
  /// **'Explain how you plan to use this data'**
  String get explainUsage;

  /// No description provided for @dataFilters.
  ///
  /// In en, this message translates to:
  /// **'Data Filters (Optional)'**
  String get dataFilters;

  /// No description provided for @categoryFilter.
  ///
  /// In en, this message translates to:
  /// **'Category Filter'**
  String get categoryFilter;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @dateRangeFilter.
  ///
  /// In en, this message translates to:
  /// **'Date Range Filter'**
  String get dateRangeFilter;

  /// No description provided for @allDates.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get allDates;

  /// No description provided for @pricingInformation.
  ///
  /// In en, this message translates to:
  /// **'Pricing Information'**
  String get pricingInformation;

  /// No description provided for @pricePerReport.
  ///
  /// In en, this message translates to:
  /// **'• 0.50 per report'**
  String get pricePerReport;

  /// No description provided for @minimumPurchase.
  ///
  /// In en, this message translates to:
  /// **'• Minimum purchase: 10.00'**
  String get minimumPurchase;

  /// No description provided for @downloadExpires.
  ///
  /// In en, this message translates to:
  /// **'• Download expires in 24 hours'**
  String get downloadExpires;

  /// No description provided for @anonymizedData.
  ///
  /// In en, this message translates to:
  /// **'• Data is fully anonymized'**
  String get anonymizedData;

  /// No description provided for @getQuote.
  ///
  /// In en, this message translates to:
  /// **'Get Quote & Purchase'**
  String get getQuote;

  /// No description provided for @reportsFound.
  ///
  /// In en, this message translates to:
  /// **'Reports found: {count}'**
  String reportsFound(Object count);

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost: {amount}'**
  String totalCost(Object amount);

  /// No description provided for @paymentNote.
  ///
  /// In en, this message translates to:
  /// **'Note: This is a demo. Payment integration would be completed here.'**
  String get paymentNote;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @proceedPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedPayment;

  /// No description provided for @moderatorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Moderator Dashboard'**
  String get moderatorDashboard;

  /// No description provided for @reportsOverview.
  ///
  /// In en, this message translates to:
  /// **'Reports Overview'**
  String get reportsOverview;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @filterReports.
  ///
  /// In en, this message translates to:
  /// **'Filter Reports'**
  String get filterReports;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get selectStatus;

  /// No description provided for @reportsList.
  ///
  /// In en, this message translates to:
  /// **'{status} Reports'**
  String reportsList(Object status);

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Report Details'**
  String get reportDetails;

  /// No description provided for @reportInformation.
  ///
  /// In en, this message translates to:
  /// **'Report Information'**
  String get reportInformation;

  /// No description provided for @referenceCode.
  ///
  /// In en, this message translates to:
  /// **'Reference Code'**
  String get referenceCode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @locationDetails.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get locationDetails;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @mapPreview.
  ///
  /// In en, this message translates to:
  /// **'Map Preview'**
  String get mapPreview;

  /// No description provided for @integrationPending.
  ///
  /// In en, this message translates to:
  /// **'Integration pending'**
  String get integrationPending;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @evidenceFile.
  ///
  /// In en, this message translates to:
  /// **'Evidence File'**
  String get evidenceFile;

  /// No description provided for @fileAvailable.
  ///
  /// In en, this message translates to:
  /// **'File available for review'**
  String get fileAvailable;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments provided'**
  String get noAttachments;

  /// No description provided for @moderationActions.
  ///
  /// In en, this message translates to:
  /// **'Moderation Actions'**
  String get moderationActions;

  /// No description provided for @moderationNotes.
  ///
  /// In en, this message translates to:
  /// **'Moderation Notes'**
  String get moderationNotes;

  /// No description provided for @reasoning.
  ///
  /// In en, this message translates to:
  /// **'Provide detailed reasoning for your decision...'**
  String get reasoning;

  /// No description provided for @verifyReport.
  ///
  /// In en, this message translates to:
  /// **'Verify Report'**
  String get verifyReport;

  /// No description provided for @rejectReport.
  ///
  /// In en, this message translates to:
  /// **'Reject Report'**
  String get rejectReport;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinCivicVoice.
  ///
  /// In en, this message translates to:
  /// **'Join CivicVoice'**
  String get joinCivicVoice;

  /// No description provided for @createAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started'**
  String get createAccountDescription;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @strongPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get strongPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reenterPassword;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and Privacy Policy'**
  String get agreeTerms;

  /// No description provided for @generalPublic.
  ///
  /// In en, this message translates to:
  /// **'General Public'**
  String get generalPublic;

  /// No description provided for @generalPublicDescription.
  ///
  /// In en, this message translates to:
  /// **'Browse reports\nSubmit anonymously\nTrack submissions'**
  String get generalPublicDescription;

  /// No description provided for @researchers.
  ///
  /// In en, this message translates to:
  /// **'Researchers'**
  String get researchers;

  /// No description provided for @researchersDescription.
  ///
  /// In en, this message translates to:
  /// **'Access data exports\nAdvanced analytics\nBulk downloads'**
  String get researchersDescription;

  /// No description provided for @moderators.
  ///
  /// In en, this message translates to:
  /// **'Moderators'**
  String get moderators;

  /// No description provided for @moderatorsDescription.
  ///
  /// In en, this message translates to:
  /// **'Verify reports • Manage content • Administrative access'**
  String get moderatorsDescription;

  /// No description provided for @mostUsers.
  ///
  /// In en, this message translates to:
  /// **'Most Users'**
  String get mostUsers;

  /// No description provided for @startBrowsing.
  ///
  /// In en, this message translates to:
  /// **'Start Browsing'**
  String get startBrowsing;

  /// No description provided for @coreFeatures.
  ///
  /// In en, this message translates to:
  /// **'Access all core features without an account'**
  String get coreFeatures;

  /// No description provided for @continueGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueGuest;

  /// No description provided for @professionalAccess.
  ///
  /// In en, this message translates to:
  /// **'Professional Access'**
  String get professionalAccess;

  /// No description provided for @forProfessionals.
  ///
  /// In en, this message translates to:
  /// **'For researchers and content moderators'**
  String get forProfessionals;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @trackYourReport.
  ///
  /// In en, this message translates to:
  /// **'Track Your Report'**
  String get trackYourReport;

  /// No description provided for @enterCredentials.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to check the status of your anonymous report.'**
  String get enterCredentials;

  /// No description provided for @referenceCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your 8-character reference code'**
  String get referenceCodeHint;

  /// No description provided for @passphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get passphrase;

  /// No description provided for @enterPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Enter your passphrase'**
  String get enterPassphrase;

  /// No description provided for @trackReportButton.
  ///
  /// In en, this message translates to:
  /// **'Track Report'**
  String get trackReportButton;

  /// No description provided for @statusHistory.
  ///
  /// In en, this message translates to:
  /// **'Status History'**
  String get statusHistory;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @reportTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Report Title'**
  String get reportTitleLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @submittedLabel.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submittedLabel;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use CivicVoice'**
  String get howToUse;

  /// No description provided for @technicalSupport.
  ///
  /// In en, this message translates to:
  /// **'For technical support, contact: support@civicvoice.app'**
  String get technicalSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About CivicVoice'**
  String get aboutApp;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'CivicVoice v1.0.0'**
  String get appVersion;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A secure platform for anonymous governance reporting and transparency.'**
  String get appDescription;

  /// No description provided for @appFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get appFeatures;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSure;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @limitedAccess.
  ///
  /// In en, this message translates to:
  /// **'Limited access • Sign in for full features'**
  String get limitedAccess;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed In'**
  String get signedIn;

  /// No description provided for @roleTools.
  ///
  /// In en, this message translates to:
  /// **'{role} TOOLS'**
  String roleTools(Object role);

  /// No description provided for @reportManagement.
  ///
  /// In en, this message translates to:
  /// **'Report Management'**
  String get reportManagement;

  /// No description provided for @detailedModeration.
  ///
  /// In en, this message translates to:
  /// **'Detailed report moderation'**
  String get detailedModeration;

  /// No description provided for @dataExport.
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get dataExport;

  /// No description provided for @downloadResearch.
  ///
  /// In en, this message translates to:
  /// **'Purchase and download research data'**
  String get downloadResearch;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @corruption.
  ///
  /// In en, this message translates to:
  /// **'Corruption'**
  String get corruption;

  /// No description provided for @infrastructure.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get infrastructure;

  /// No description provided for @healthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get healthcare;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @publicSafety.
  ///
  /// In en, this message translates to:
  /// **'Public Safety'**
  String get publicSafety;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @housing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get housing;

  /// No description provided for @employment.
  ///
  /// In en, this message translates to:
  /// **'Employment'**
  String get employment;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
