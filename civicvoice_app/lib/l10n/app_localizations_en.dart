// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CivicVoice';

  @override
  String get anonymous => '100% Anonymous';

  @override
  String get anonymousDescription =>
      'Report governance issues safely without revealing your identity. Your privacy is our priority.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get reportSubmitted => 'Report Submitted!';

  @override
  String get reportSubmittedDescription =>
      'Your report has been submitted anonymously';

  @override
  String get copyCode => 'Copy Code';

  @override
  String get returnHome => 'Return Home';

  @override
  String get trackReport => 'Track Report';

  @override
  String get checkStatus => 'Check Status';

  @override
  String get moderatorAccess => 'Moderator Access';

  @override
  String get loginSecurely => 'Login Securely';

  @override
  String get publicDashboard => 'Public Dashboard';

  @override
  String get requestDataPackage => 'Request Data Package';

  @override
  String get settings => 'Settings';

  @override
  String get reportTitle => 'Report Title';

  @override
  String get briefTitle => 'Brief, clear title of the issue';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select issue category';

  @override
  String get location => 'Location';

  @override
  String get searchCity => 'Search for a city';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get detailedInfo => 'Provide detailed information about the issue...';

  @override
  String get addAttachment => 'Add Attachment';

  @override
  String get addAttachmentOptional => 'Add Attachment (Optional)';

  @override
  String get attachmentTypes => 'Photos, documents, or other evidence';

  @override
  String get submitAnonymously => 'Submit Anonymously';

  @override
  String get privacyNotice =>
      'Your report is completely anonymous. We do not collect any personal information that could identify you.';

  @override
  String get helpPrivacy => 'Help & Privacy';

  @override
  String get completeAnonymity => 'Complete Anonymity';

  @override
  String get anonymityDescription =>
      'Your personal information is never collected or stored. Reports cannot be traced back to you.';

  @override
  String get whatToInclude => 'What to Include';

  @override
  String get includeDescription =>
      '• Clear, factual description\n• Specific location\n• Supporting documents if available\n• Date and time when possible';

  @override
  String get reportProcess => 'Report Process';

  @override
  String get processDescription =>
      'Reports are reviewed by verified moderators and may be published on the public dashboard after verification.';

  @override
  String get gotIt => 'Got it';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get submitReportAction => 'Submit Report';

  @override
  String get trackStatusAction => 'Track Status';

  @override
  String get browseReports => 'Browse Reports';

  @override
  String get appSettings => 'Settings';

  @override
  String get recentReports => 'Recent Reports';

  @override
  String get viewAll => 'View All';

  @override
  String get platformStatistics => 'Platform Statistics';

  @override
  String get totalReports => 'Total Reports';

  @override
  String get allSubmissions => 'All submissions';

  @override
  String get recentReportsCount => 'Recent Reports';

  @override
  String get lastVerified => 'Last 3 verified';

  @override
  String welcomeBack(Object userName) {
    return 'Welcome back, $userName!';
  }

  @override
  String get makeDifference => 'Ready to make a difference today?';

  @override
  String get welcomeGuest => 'Welcome to CivicVoice!';

  @override
  String get browseSubmit => 'Browse reports or submit anonymously';

  @override
  String get registerPrompt =>
      'Register as a researcher or moderator to access advanced features';

  @override
  String get privacyProtected =>
      'Your privacy is protected with end-to-end encryption';

  @override
  String get signUp => 'Sign Up';

  @override
  String get requestResearchData => 'Request Research Data';

  @override
  String get purchaseDescription =>
      'Purchase anonymized governance report data for research purposes.';

  @override
  String get organization => 'Organization';

  @override
  String get researchInstitution => 'Your research institution or organization';

  @override
  String get researchPurpose => 'Research Purpose';

  @override
  String get explainUsage => 'Explain how you plan to use this data';

  @override
  String get dataFilters => 'Data Filters (Optional)';

  @override
  String get categoryFilter => 'Category Filter';

  @override
  String get allCategories => 'All Categories';

  @override
  String get dateRangeFilter => 'Date Range Filter';

  @override
  String get allDates => 'All dates';

  @override
  String get pricingInformation => 'Pricing Information';

  @override
  String get pricePerReport => '• 0.50 per report';

  @override
  String get minimumPurchase => '• Minimum purchase: 10.00';

  @override
  String get downloadExpires => '• Download expires in 24 hours';

  @override
  String get anonymizedData => '• Data is fully anonymized';

  @override
  String get getQuote => 'Get Quote & Purchase';

  @override
  String reportsFound(Object count) {
    return 'Reports found: $count';
  }

  @override
  String totalCost(Object amount) {
    return 'Total cost: $amount';
  }

  @override
  String get paymentNote =>
      'Note: This is a demo. Payment integration would be completed here.';

  @override
  String get cancel => 'Cancel';

  @override
  String get proceedPayment => 'Proceed to Payment';

  @override
  String get moderatorDashboard => 'Moderator Dashboard';

  @override
  String get reportsOverview => 'Reports Overview';

  @override
  String get pending => 'Pending';

  @override
  String get verified => 'Verified';

  @override
  String get rejected => 'Rejected';

  @override
  String get filterReports => 'Filter Reports';

  @override
  String get status => 'Status';

  @override
  String get selectStatus => 'Select status';

  @override
  String reportsList(Object status) {
    return '$status Reports';
  }

  @override
  String get reportDetails => 'Report Details';

  @override
  String get reportInformation => 'Report Information';

  @override
  String get referenceCode => 'Reference Code';

  @override
  String get language => 'Language';

  @override
  String get submitted => 'Submitted';

  @override
  String get statusLabel => 'Status';

  @override
  String get locationDetails => 'Location Details';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get notAvailable => 'Not available';

  @override
  String get mapPreview => 'Map Preview';

  @override
  String get integrationPending => 'Integration pending';

  @override
  String get attachments => 'Attachments';

  @override
  String get evidenceFile => 'Evidence File';

  @override
  String get fileAvailable => 'File available for review';

  @override
  String get view => 'View';

  @override
  String get noAttachments => 'No attachments provided';

  @override
  String get moderationActions => 'Moderation Actions';

  @override
  String get moderationNotes => 'Moderation Notes';

  @override
  String get reasoning => 'Provide detailed reasoning for your decision...';

  @override
  String get verifyReport => 'Verify Report';

  @override
  String get rejectReport => 'Reject Report';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinCivicVoice => 'Join CivicVoice';

  @override
  String get createAccountDescription => 'Create your account to get started';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get strongPassword => 'Create a strong password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reenterPassword => 'Re-enter your password';

  @override
  String get agreeTerms => 'I agree to the Terms of Service and Privacy Policy';

  @override
  String get generalPublic => 'General Public';

  @override
  String get generalPublicDescription =>
      'Browse reports\nSubmit anonymously\nTrack submissions';

  @override
  String get researchers => 'Researchers';

  @override
  String get researchersDescription =>
      'Access data exports\nAdvanced analytics\nBulk downloads';

  @override
  String get moderators => 'Moderators';

  @override
  String get moderatorsDescription =>
      'Verify reports • Manage content • Administrative access';

  @override
  String get mostUsers => 'Most Users';

  @override
  String get startBrowsing => 'Start Browsing';

  @override
  String get coreFeatures => 'Access all core features without an account';

  @override
  String get continueGuest => 'Continue as Guest';

  @override
  String get professionalAccess => 'Professional Access';

  @override
  String get forProfessionals => 'For researchers and content moderators';

  @override
  String get register => 'Register';

  @override
  String get signIn => 'Sign In';

  @override
  String get trackYourReport => 'Track Your Report';

  @override
  String get enterCredentials =>
      'Enter your credentials to check the status of your anonymous report.';

  @override
  String get referenceCodeHint => 'Enter your 8-character reference code';

  @override
  String get passphrase => 'Passphrase';

  @override
  String get enterPassphrase => 'Enter your passphrase';

  @override
  String get trackReportButton => 'Track Report';

  @override
  String get statusHistory => 'Status History';

  @override
  String get latest => 'Latest';

  @override
  String get reportTitleLabel => 'Report Title';

  @override
  String get categoryLabel => 'Category';

  @override
  String get submittedLabel => 'Submitted';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get howToUse => 'How to use CivicVoice';

  @override
  String get technicalSupport =>
      'For technical support, contact: support@civicvoice.app';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get dataCollection => 'Data Collection';

  @override
  String get dataUsage => 'Data Usage';

  @override
  String get dataSecurity => 'Data Security';

  @override
  String get aboutApp => 'About CivicVoice';

  @override
  String get appVersion => 'CivicVoice v1.0.0';

  @override
  String get appDescription =>
      'A secure platform for anonymous governance reporting and transparency.';

  @override
  String get appFeatures => 'Features';

  @override
  String get signOut => 'Sign Out';

  @override
  String get areYouSure => 'Are you sure you want to sign out?';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get systemDefault => 'System Default';

  @override
  String get account => 'Account';

  @override
  String get guestUser => 'Guest User';

  @override
  String get limitedAccess => 'Limited access • Sign in for full features';

  @override
  String get signedIn => 'Signed In';

  @override
  String roleTools(Object role) {
    return '$role TOOLS';
  }

  @override
  String get reportManagement => 'Report Management';

  @override
  String get detailedModeration => 'Detailed report moderation';

  @override
  String get dataExport => 'Data Export';

  @override
  String get downloadResearch => 'Purchase and download research data';

  @override
  String get appearance => 'Appearance';

  @override
  String get notifications => 'Notifications';

  @override
  String get support => 'Support';

  @override
  String get about => 'About';

  @override
  String get corruption => 'Corruption';

  @override
  String get infrastructure => 'Infrastructure';

  @override
  String get healthcare => 'Healthcare';

  @override
  String get education => 'Education';

  @override
  String get environment => 'Environment';

  @override
  String get publicSafety => 'Public Safety';

  @override
  String get transportation => 'Transportation';

  @override
  String get housing => 'Housing';

  @override
  String get employment => 'Employment';

  @override
  String get other => 'Other';
}
