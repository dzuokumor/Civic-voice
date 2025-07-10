import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'landing_page_screen.dart';
import 'public_open_dashboard_screen.dart';

void main() {
  runApp(const CivicVoiceApp());
}

// Theme Constants
class AppColors {
  static const Color primary = Color(0xFF673AB7);
  static const Color accent = Color(0xFF9C27B0);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
}

enum AppLanguage { en, fr }

class AppLocalizations {
  static AppLanguage currentLanguage = AppLanguage.en;
  static final Map<AppLanguage, Map<String, String>> _localizedValues = {
    AppLanguage.en: {
      'appTitle': 'CivicVoice',
      'anonymous': '100% Anonymous',
      'anonymousDescription': 'Report governance issues safely without revealing your identity. Your privacy is our priority.',
      'getStarted': 'Get Started',
      'submitReport': 'Submit Report',
      'reportSubmitted': 'Report Submitted!',
      'reportSubmittedDescription': 'Your report has been submitted anonymously',
      'referenceCode': 'Reference Code',
      'passphrase': 'Passphrase',
      'copyCode': 'Copy Code',
      'returnHome': 'Return Home',
      'trackReport': 'Track Report',
      'checkStatus': 'Check Status',
      'moderatorAccess': 'Moderator Access',
      'loginSecurely': 'Login Securely',
      'publicDashboard': 'Public Dashboard',
      'requestDataPackage': 'Request Data Package',
      'settings': 'Settings',
      'attachProof': 'Attach Proof',
      'selectLanguage': 'Select Language',
      'english': 'English',
      'french': 'Français',
      'fileAttached': 'File attached',
      'noFile': 'No file selected',
      'tapToCopy': 'Tap to copy',
      'passphraseHint': '6-digit code',
    },
    AppLanguage.fr: {
      'appTitle': 'CivicVoice',
      'anonymous': '100% Anonyme',
      'anonymousDescription': 'Signalez les problèmes de gouvernance en toute sécurité sans révéler votre identité. Votre vie privée est notre priorité.',
      'getStarted': 'Commencer',
      'submitReport': 'Soumettre un rapport',
      'reportSubmitted': 'Rapport soumis!',
      'reportSubmittedDescription': 'Votre rapport a été soumis anonymement',
      'referenceCode': 'Code de référence',
      'passphrase': 'Phrase secrète',
      'copyCode': 'Copier le code',
      'returnHome': 'Retour à l\'accueil',
      'trackReport': 'Suivre le rapport',
      'checkStatus': 'Vérifier le statut',
      'moderatorAccess': 'Accès modérateur',
      'loginSecurely': 'Connexion sécurisée',
      'publicDashboard': 'Tableau de bord public',
      'requestDataPackage': 'Demander un package de données',
      'settings': 'Paramètres',
      'attachProof': 'Joindre une preuve',
      'selectLanguage': 'Choisir la langue',
      'english': 'Anglais',
      'french': 'Français',
      'fileAttached': 'Fichier joint',
      'noFile': 'Aucun fichier sélectionné',
      'tapToCopy': 'Appuyez pour copier',
      'passphraseHint': 'Code à 6 chiffres',
    },
  };
  static String t(String key) => _localizedValues[currentLanguage]?[key] ?? key;
}

class AppRoutes {
  static const String splash = '/';
  static const String landing = '/landing';
  static const String onboarding = '/onboarding';
  static const String reportForm = '/anonymousReportForm';
  static const String submissionConfirmation = '/submissionConfirmation';
  static const String trackStatus = '/trackReportStatus';
  static const String moderatorLogin = '/moderatorLogin';
  static const String moderatorDashboard = '/moderatorDashboard';
  static const String moderatorReportDetail = '/moderatorReportDetail';
  static const String publicDashboard = '/publicOpenDashboard';
  static const String dataPurchase = '/dataPurchase';
  static const String settings = '/settings';
}

class CivicVoiceApp extends StatefulWidget {
  const CivicVoiceApp({super.key});
  @override
  State<CivicVoiceApp> createState() => _CivicVoiceAppState();
}

class _CivicVoiceAppState extends State<CivicVoiceApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.t('appTitle'),
      theme: _buildTheme(),
      initialRoute: AppRoutes.splash,
      routes: _buildRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.cardBackground,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.landing: (context) => const LandingPageScreen(),
      AppRoutes.onboarding: (context) => const OnboardingScreen(),
      AppRoutes.reportForm: (context) => AnonymousReportFormScreen(onLanguageChanged: _onLanguageChanged),
      AppRoutes.submissionConfirmation: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
        return SubmissionConfirmationScreen(
          referenceCode: args?['referenceCode'] ?? '',
          passphrase: args?['passphrase'] ?? '',
        );
      },
      AppRoutes.trackStatus: (context) => const TrackReportStatusScreen(),
      AppRoutes.moderatorLogin: (context) => const ModeratorLoginScreen(),
      AppRoutes.moderatorDashboard: (context) => const ModeratorDashboardScreen(),
      AppRoutes.moderatorReportDetail: (context) => const ModeratorReportDetailScreen(),
      AppRoutes.publicDashboard: (context) => const PublicOpenDashboardScreen(),
      AppRoutes.dataPurchase: (context) => const DataPurchaseScreen(),
      AppRoutes.settings: (context) => SettingsScreen(onLanguageChanged: _onLanguageChanged),
    };
  }

  void _onLanguageChanged(AppLanguage lang) {
    setState(() {
      AppLocalizations.currentLanguage = lang;
    });
  }
}

// Common Widgets
class MainNavigation extends StatelessWidget {
  final Widget child;
  final bool showBottomNav;
  final int currentIndex;

  const MainNavigation({
    super.key,
    required this.child,
    this.showBottomNav = true,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: showBottomNav ? _buildBottomNavigationBar(context) : null,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Report'),
        BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Track'),
        BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Public'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) => _handleNavigation(context, index),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    final routes = [
      AppRoutes.onboarding,
      AppRoutes.reportForm,
      AppRoutes.trackStatus,
      AppRoutes.publicDashboard,
      AppRoutes.settings,
    ];
    
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, routes[index], (route) => false);
    } else {
      Navigator.pushNamed(context, routes[index]);
    }
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding!,
        child: child,
      ),
    );
  }
}

class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double size;

  const IconContainer({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
    required this.backgroundColor,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 2,
      height: size * 2,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}

// Screens
// SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Changed from 2 to 5 seconds
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.landing);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.gavel, color: AppColors.primary, size: 80),
            ),
          ),
        ),
      ),
    );
  }
}
// ONBOARDING SCREEN
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconContainer(
                  icon: Icons.lock_rounded,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.t('anonymous'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.t('anonymousDescription'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.reportForm),
                  child: Text(AppLocalizations.t('getStarted')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ANONYMOUS REPORT SCREEN
class AnonymousReportFormScreen extends StatefulWidget {
  final void Function(AppLanguage)? onLanguageChanged;
  const AnonymousReportFormScreen({super.key, this.onLanguageChanged});
  @override
  State<AnonymousReportFormScreen> createState() => _AnonymousReportFormScreenState();
}

class _AnonymousReportFormScreenState extends State<AnonymousReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  String _location = 'Tap to select location';
  File? _attachment;
  AppLanguage _selectedLanguage = AppLocalizations.currentLanguage;
  static const List<String> _categories = ['Corruption', 'Mismanagement', 'Abuse of Power', 'Other'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachment = File(result.files.single.path!);
      });
    }
  }

  String _generatePassphrase() {
    final rand = Random();
    return List.generate(6, (_) => rand.nextInt(10)).join();
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      final referenceCode = 'REF-${DateTime.now().year}-${_titleController.text.hashCode.abs()}';
      final passphrase = _generatePassphrase();
      Navigator.of(context).pushNamed(
        AppRoutes.submissionConfirmation,
        arguments: {
          'referenceCode': referenceCode,
          'passphrase': passphrase,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 1,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildTitleField(),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),
                _buildLocationField(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildAttachmentField(),
                const SizedBox(height: 16),
                _buildLanguageDropdown(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.description, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Text(
          AppLocalizations.t('submitReport'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Report Title',
        hintText: 'Brief title of the issue',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) => value?.isEmpty == true ? 'Please enter a title' : null,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      hint: const Text('Select category'),
      decoration: const InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category),
      ),
      items: _categories.map((category) => 
        DropdownMenuItem(value: category, child: Text(category))
      ).toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (value) => value?.isEmpty == true ? 'Please select a category' : null,
    );
  }

  Widget _buildLocationField() {
    return GestureDetector(
      onTap: () => setState(() => _location = 'Kigali City'),
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: 'Location',
          hintText: _location,
          prefixIcon: const Icon(Icons.location_on),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        hintText: 'Provide more details about the issue...',
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildAttachmentField() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _pickAttachment,
          icon: const Icon(Icons.attach_file),
          label: Text(AppLocalizations.t('attachProof')),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(_attachment != null ? AppLocalizations.t('fileAttached') : AppLocalizations.t('noFile')),
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButtonFormField<AppLanguage>(
      value: _selectedLanguage,
      decoration: InputDecoration(
        labelText: AppLocalizations.t('selectLanguage'),
        prefixIcon: const Icon(Icons.language),
      ),
      items: AppLanguage.values.map((lang) => DropdownMenuItem(
        value: lang,
        child: Text(AppLocalizations._localizedValues[lang]!['english']!),
      )).toList(),
      onChanged: (lang) {
        if (lang != null) {
          setState(() => _selectedLanguage = lang);
          AppLocalizations.currentLanguage = lang;
          if (widget.onLanguageChanged != null) widget.onLanguageChanged!(lang);
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitReport,
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      child: const Text('Submit Anonymously'),
    );
  }
}
// SUBMISSION CONFIRMATION
class SubmissionConfirmationScreen extends StatelessWidget {
  final String referenceCode;
  final String passphrase;
  const SubmissionConfirmationScreen({super.key, required this.referenceCode, required this.passphrase});

  void _copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${AppLocalizations.t('copyCode')}: $value')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      showBottomNav: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconContainer(
                  icon: Icons.check_circle,
                  color: AppColors.success,
                  backgroundColor: AppColors.success.withOpacity(0.1),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.t('reportSubmitted'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.t('reportSubmittedDescription'),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildReferenceCodeContainer(context),
                const SizedBox(height: 16),
                _buildPassphraseContainer(context),
                const SizedBox(height: 24),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReferenceCodeContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.t('referenceCode'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _copyToClipboard(context, referenceCode),
            child: Text(
              referenceCode,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.t('tapToCopy'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildPassphraseContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.t('passphrase'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _copyToClipboard(context, passphrase),
            child: Text(
              passphrase,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.t('tapToCopy'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _copyToClipboard(context, referenceCode),
            child: Text(AppLocalizations.t('copyCode')),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Text(AppLocalizations.t('returnHome')),
          ),
        ),
      ],
    );
  }
}

// TRACKING REPORT STATUS
class TrackReportStatusScreen extends StatefulWidget {
  const TrackReportStatusScreen({super.key});

  @override
  State<TrackReportStatusScreen> createState() => _TrackReportStatusScreenState();
}

class _TrackReportStatusScreenState extends State<TrackReportStatusScreen> {
  final _referenceCodeController = TextEditingController();
  String _currentStatus = 'Not Checked';
  String _lastUpdated = '';

  @override
  void dispose() {
    _referenceCodeController.dispose();
    super.dispose();
  }

  void _checkStatus() {
    if (_referenceCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reference code')),
      );
      return;
    }
    setState(() {
      _currentStatus = 'Under Review';
      _lastUpdated = DateTime.now().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildReferenceCodeField(),
              const SizedBox(height: 16),
              _buildCheckStatusButton(),
              const SizedBox(height: 24),
              _buildStatusContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.track_changes, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Text(
          AppLocalizations.t('trackReport'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceCodeField() {
    return TextFormField(
      controller: _referenceCodeController,
      decoration: const InputDecoration(
        labelText: 'Reference Code',
        hintText: 'Enter your reference code',
        prefixIcon: Icon(Icons.code),
      ),
    );
  }

  Widget _buildCheckStatusButton() {
    return ElevatedButton(
      onPressed: _checkStatus,
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      child: Text(AppLocalizations.t('checkStatus')),
    );
  }

  Widget _buildStatusContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Status',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Status:', style: Theme.of(context).textTheme.bodyLarge),
              const Spacer(),
              Chip(
                backgroundColor: AppColors.warning.withOpacity(0.1),
                label: Text(_currentStatus, style: const TextStyle(color: AppColors.warning)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Submitted: 2 days ago', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Last Updated: $_lastUpdated', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// MODERATOR LOGIN SCREEN
class ModeratorLoginScreen extends StatelessWidget {
  const ModeratorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Moderator Access',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'moderator@gmail.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (_) {}),
                  const Text('Enable 2FA'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ModeratorDashboardScreen()),
                  );
                },
                child: const Text('Login Securely'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// MODERATOR DASHBOARD SCREEN
class ModeratorDashboardScreen extends StatelessWidget {
  const ModeratorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Moderator Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Pending Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ReportCard(
              title: 'Corruption Report',
              subtitle: 'Submitted: 2 hours ago • Kigali',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ModeratorReportDetailScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ReportCard(
              title: 'Mismanagement Issue',
              subtitle: 'Click to view details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ModeratorReportDetailScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Chip(label: Text('Pending')),
        onTap: onTap,
      ),
    );
  }
}

// MODERATOR REPORT DETAIL SCREEN
class ModeratorReportDetailScreen extends StatelessWidget {
  const ModeratorReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Report Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title: Corruption in Local Office',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Category: Corruption'),
            const Text('Location: Kigali City'),
            const SizedBox(height: 20),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Add verification notes...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Verify'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text('Reject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// PUBLIC OPEN DASHBOARD SCREEN
// class PublicOpenDashboardScreen extends StatelessWidget {
//   const PublicOpenDashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MainNavigation(
//       currentIndex: 3,
//       child: Center(child: Text('Public Dashboard Screen')),
//     );
//   }
// }
// DATA PURCHASE SCREEN
class DataPurchaseScreen extends StatelessWidget {
  const DataPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainNavigation(
      showBottomNav: false,
      child: Center(child: Text('Data Purchase Screen')),
    );
  }
}
// SETTINGS SCREEN
class SettingsScreen extends StatelessWidget {
  final void Function(AppLanguage)? onLanguageChanged;
  const SettingsScreen({super.key, this.onLanguageChanged});
  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.t('settings'), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            DropdownButton<AppLanguage>(
              value: AppLocalizations.currentLanguage,
              items: AppLanguage.values.map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(AppLocalizations._localizedValues[lang]!['english']!),
              )).toList(),
              onChanged: (lang) {
                if (lang != null && onLanguageChanged != null) {
                  onLanguageChanged!(lang);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}