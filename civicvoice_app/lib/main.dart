import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'domain/blocs.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/anonymous_report_form_screen.dart';
import 'presentation/screens/submission_confirmation_screen.dart';
import 'presentation/screens/track_report_status_screen.dart';
import 'presentation/screens/moderator_login_screen.dart';
import 'presentation/screens/moderator_dashboard_screen.dart';
import 'presentation/screens/public_open_dashboard_screen.dart';
import 'presentation/screens/settings_screen.dart';

import 'domain/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBloc.storage = storage;

  await DatabaseHelper.instance.database;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CivicVoiceApp());
}

class CivicVoiceApp extends StatelessWidget {
  const CivicVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (_) => ReportBloc(),
        ),
        BlocProvider(
          create: (_) => LanguageBloc()..add(LoadLanguageEvent()),
        ),
        BlocProvider(
          create: (_) => DataPurchaseBloc(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return MaterialApp(
            title: AppStrings.appTitle,
            theme: _buildTheme(),
            darkTheme: _buildDarkTheme(),
            locale: languageState.locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('fr', 'FR'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRoutes.splash,
            routes: _buildRoutes(),
            onGenerateRoute: _onGenerateRoute,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return ConnectivityWrapper(child: child!);
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: Colors.white,
        background: AppColors.background,
      ),
      useMaterial3: true,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
        surfaceTintColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: const Color(0xFF1E1E1E),
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 0,
        surfaceTintColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.onboarding: (context) => const OnboardingScreen(),
      AppRoutes.reportForm: (context) => const AnonymousReportFormScreen(),
      AppRoutes.trackStatus: (context) => const TrackReportStatusScreen(),
      AppRoutes.moderatorLogin: (context) => const ModeratorLoginScreen(),
      AppRoutes.moderatorDashboard: (context) => const ModeratorDashboardScreen(),
      AppRoutes.publicDashboard: (context) => const PublicOpenDashboardScreen(),
      AppRoutes.settings: (context) => const SettingsScreen(),
    };
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/submissionConfirmation':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => SubmissionConfirmationScreen(
            submissionData: args ?? {},
          ),
        );
      case '/trackReportStatus':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => TrackReportStatusScreen(
            initialCredentials: args,
          ),
        );
      default:
        return null;
    }
  }
}

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late Stream<List<ConnectivityResult>> _connectivityStream;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _connectivityStream = Connectivity().onConnectivityChanged;
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateConnectionStatus(results);
        }
      });
    } catch (e) {
      if (kIsWeb) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _isOnline = true);
          }
        });
      }
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (mounted) {
      setState(() {
        _isOnline = results.any((result) => result != ConnectivityResult.none);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: _connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState != ConnectionState.waiting) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _updateConnectionStatus(snapshot.data!);
            }
          });
        }

        return Stack(
          children: [
            widget.child,
            if (!kIsWeb && !_isOnline)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'No internet connection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

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

class AppStrings {
  static const String appTitle = 'CivicVoice';
  static const String anonymous = '100% Anonymous';
  static const String anonymousDescription = 'Report governance issues safely without revealing your identity. Your privacy is our priority.';
  static const String getStarted = 'Get Started';
  static const String submitReport = 'Submit Report';
  static const String reportSubmitted = 'Report Submitted!';
  static const String reportSubmittedDescription = 'Your report has been submitted anonymously';
  static const String referenceCode = 'Reference Code';
  static const String copyCode = 'Copy Code';
  static const String returnHome = 'Return Home';
  static const String trackReport = 'Track Report';
  static const String checkStatus = 'Check Status';
  static const String moderatorAccess = 'Moderator Access';
  static const String loginSecurely = 'Login Securely';
  static const String publicDashboard = 'Public Dashboard';
  static const String requestDataPackage = 'Request Data Package';
  static const String settings = 'Settings';
}

class AppRoutes {
  static const String splash = '/';
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