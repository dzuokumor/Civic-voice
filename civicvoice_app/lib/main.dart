import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CivicVoiceApp());
}

const Color primaryColor = Color(0xFF673AB7);
const Color accentColor = Color(0xFF9C27B0);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color cardBackgroundColor = Colors.white;
const Color successColor = Color(0xFF4CAF50);
const Color errorColor = Color(0xFFF44336);
const Color warningColor = Color(0xFFFFC107);
const Color textColor = Color(0xFF333333);
const Color secondaryTextColor = Color(0xFF666666);

class CivicVoiceApp extends StatelessWidget {
  const CivicVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CivicVoice',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: cardBackgroundColor,
          margin: const EdgeInsets.all(16),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/anonymousReportForm': (context) => const AnonymousReportFormScreen(),
        '/submissionConfirmation': (context) => const SubmissionConfirmationScreen(referenceCode: 'REF-2025-001234'),
        '/trackReportStatus': (context) => const TrackReportStatusScreen(),
        '/moderatorLogin': (context) => const ModeratorLoginScreen(),
        '/moderatorDashboard': (context) => const ModeratorDashboardScreen(),
        '/moderatorReportDetail': (context) => const ModeratorReportDetailScreen(),
        '/publicOpenDashboard': (context) => const PublicOpenDashboardScreen(),
        '/dataPurchase': (context) => const DataPurchaseScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}


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
      bottomNavigationBar: showBottomNav ? BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryTextColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Public',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(context, '/onboarding', (route) => false);
              break;
            case 1:
              Navigator.pushNamed(context, '/anonymousReportForm');
              break;
            case 2:
              Navigator.pushNamed(context, '/trackReportStatus');
              break;
            case 3:
              Navigator.pushNamed(context, '/publicOpenDashboard');
              break;
            case 4:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ) : null,
    );
  }
}

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
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
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
            colors: [primaryColor, accentColor],
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
              child: const Icon(
                Icons.gavel,
                color: primaryColor,
                size: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 50,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '100% Anonymous',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 24),
                  Text(
                    'Report governance issues safely without revealing your identity. Your privacy is our priority.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/anonymousReportForm');
                    },
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    ));
  }
}

class AnonymousReportFormScreen extends StatefulWidget {
  const AnonymousReportFormScreen({super.key});

  @override
  State<AnonymousReportFormScreen> createState() => _AnonymousReportFormScreenState();
}

class _AnonymousReportFormScreenState extends State<AnonymousReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['Corruption', 'Mismanagement', 'Abuse of Power', 'Other'];
  String _location = 'Tap to select location';

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamed(
        '/submissionConfirmation',
        arguments: 'REF-${DateTime.now().year}-${_titleController.text.hashCode.abs()}',
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
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.description,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Submit Report',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Report Title',
                          hintText: 'Brief title of the issue',
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        hint: const Text('Select category'),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _location = 'Kigali City';
                          });
                        },
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            hintText: _location,
                            prefixIcon: const Icon(Icons.location_on),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          hintText: 'Provide more details about the issue...',
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitReport,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Submit Anonymously'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmissionConfirmationScreen extends StatelessWidget {
  final String referenceCode;
  const SubmissionConfirmationScreen({super.key, required this.referenceCode});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: referenceCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reference code copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      showBottomNav: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: successColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          size: 50,
                          color: successColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Report Submitted!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 24),
                      Text(
                        'Your report has been submitted anonymously',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Reference Code',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _copyToClipboard(context),
                              child: Text(
                                referenceCode,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to copy',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _copyToClipboard(context),
                              child: const Text('Copy Code'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              child: const Text('Return Home'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackReportStatusScreen extends StatefulWidget {
  const TrackReportStatusScreen({super.key});

  @override
  State<TrackReportStatusScreen> createState() => _TrackReportStatusScreenState();
}

class _TrackReportStatusScreenState extends State<TrackReportStatusScreen> {
  final TextEditingController _referenceCodeController = TextEditingController();
  String _currentStatus = 'Not Checked';
  String _lastUpdated = '';

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
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.track_changes,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Track Report',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _referenceCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Reference Code',
                        hintText: 'Enter your reference code',
                        prefixIcon: Icon(Icons.code),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _checkStatus,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Check Status'),
                    ),
                    const SizedBox(height: 24),
                    Container(
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
                              Text(
                                'Status:',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              Chip(
                                backgroundColor: warningColor.withOpacity(0.1),
                                label: Text(
                                  _currentStatus,
                                  style: TextStyle(color: warningColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Submitted: 2 days ago',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Last Updated: $_lastUpdated',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModeratorLoginScreen extends StatefulWidget {
  const ModeratorLoginScreen({super.key});

  @override
  State<ModeratorLoginScreen> createState() => _ModeratorLoginScreenState();
}

class _ModeratorLoginScreenState extends State<ModeratorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed('/moderatorDashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      showBottomNav: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.security,
                              size: 50,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Moderator Access',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'moderator@example.com',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: '********',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              const Text('Remember me'),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Forgot password?'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Login Securely'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ModeratorDashboardScreen extends StatelessWidget {
  const ModeratorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.dashboard, size: 24, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Pending Reports',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: 'All Categories',
                            items: const [
                              DropdownMenuItem(value: 'All Categories', child: Text('All Categories')),
                              DropdownMenuItem(value: 'Corruption', child: Text('Corruption')),
                              DropdownMenuItem(value: 'Mismanagement', child: Text('Mismanagement')),
                            ],
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: 'All Locations',
                            items: const [
                              DropdownMenuItem(value: 'All Locations', child: Text('All Locations')),
                              DropdownMenuItem(value: 'Kigali', child: Text('Kigali')),
                              DropdownMenuItem(value: 'Butare', child: Text('Butare')),
                            ],
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildReportItem(context, 'Corruption Report', '2 hours ago', 'Kigali', 'Pending'),
                    const SizedBox(height: 8),
                    _buildReportItem(context, 'Mismanagement Issue', '5 hours ago', 'Butare', 'Pending'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, String title, String time, String location, String status) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: ListTile(
        title: Text(title),
        subtitle: Text('$time • $location'),
        trailing: Chip(
          backgroundColor: warningColor.withOpacity(0.1),
          label: Text(status, style: TextStyle(color: warningColor)),
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/moderatorReportDetail');
        },
      ),
    );
  }
}

class ModeratorReportDetailScreen extends StatelessWidget {
  const ModeratorReportDetailScreen({super.key});

  void _showActionDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Report'),
        content: Text('Are you sure you want to $action this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Report $action successfully')),
              );
            },
            child: Text(action, style: TextStyle(color: action == 'Verify' ? successColor : errorColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 24, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Report Details',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(context, 'Title:', 'Corruption in Local Office'),
                    _buildDetailRow(context, 'Category:', 'Corruption'),
                    _buildDetailRow(context, 'Location:', 'Kigali City'),
                    _buildDetailRow(context, 'Submitted:', '2 days ago'),
                    _buildDetailRow(context, 'Status:', 'Pending'),
                    const SizedBox(height: 16),
                    const Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Details about the corruption case would be displayed here. This is a sample description text.',
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Verification Notes',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showActionDialog(context, 'Verify'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: successColor,
                            ),
                            child: const Text('Verify'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showActionDialog(context, 'Reject'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: errorColor,
                            ),
                            child: const Text('Reject'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class PublicOpenDashboardScreen extends StatelessWidget {
  const PublicOpenDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.public, size: 24, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Public Dashboard',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map, size: 50, color: primaryColor),
                            SizedBox(height: 8),
                            Text('Interactive Heatmap'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('45', 'Corruption', warningColor),
                        _buildStatItem('23', 'Verified', successColor),
                        _buildStatItem('12', 'This Week', primaryColor),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/dataPurchase');
                      },
                      child: const Text('Request Data Package'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

class DataPurchaseScreen extends StatefulWidget {
  const DataPurchaseScreen({super.key});

  @override
  State<DataPurchaseScreen> createState() => _DataPurchaseScreenState();
}

class _DataPurchaseScreenState extends State<DataPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _purchaseData() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Purchase Successful'),
          content: Text('Thank you! Download link sent to ${_emailController.text}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      showBottomNav: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cloud_download, size: 24, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Research Access',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _organizationController,
                        decoration: const InputDecoration(
                          labelText: 'Organization',
                          hintText: 'Research Institute Name',
                          prefixIcon: Icon(Icons.business),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter organization name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'researcher@institute.edu',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data Package',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            const Text('Anonymized CSV export'),
                            const SizedBox(height: 8),
                            Text(
                              '\$99 USD',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _purchaseData,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Purchase & Download'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 4,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings, size: 24, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Settings',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsItem(
                      context,
                      Icons.language,
                      'Language',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Language selection')),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      context,
                      Icons.help_outline,
                      'Help & FAQs',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Help & FAQs')),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      context,
                      Icons.privacy_tip,
                      'Privacy Policy',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Privacy Policy')),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      context,
                      Icons.logout,
                      'Logout',
                      isLogout: true,
                      onTap: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context,
      IconData icon,
      String title, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? errorColor : primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? errorColor : textColor,
        ),
      ),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}