import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For copying to clipboard

void main() {
  runApp(const CivicVoiceApp());
}

// Define common colors based on the Figma design
const Color primaryColor = Color(0xFF673AB7); // A shade of purple
const Color accentColor = Color(0xFF9C27B0); // Another shade of purple for gradients
const Color backgroundColor = Color(0xFFE0F7FA); // Light blue background
const Color cardBackgroundColor = Colors.white;
const Color successColor = Color(0xFF4CAF50); // Green for verify/success
const Color errorColor = Color(0xFFF44336); // Red for reject/error
const Color warningColor = Color(0xFFFFC107); // Amber for 'Pending'

class CivicVoiceApp extends StatelessWidget {
  const CivicVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CivicVoice',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'Inter', // Assuming 'Inter' as a modern sans-serif font
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: cardBackgroundColor,
          margin: const EdgeInsets.all(16.0),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/anonymousReportForm': (context) => const AnonymousReportFormScreen(),
        '/submissionConfirmation': (context) => const SubmissionConfirmationScreen(referenceCode: 'REF-2025-001234'), // Placeholder
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

// 1. Splash Screen
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
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCirc,
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to onboarding after animation
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
            colors: [primaryColor, accentColor], // Gradient from Figma
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
                Icons.gavel, // Using a hammer/gavel icon as a placeholder for "Civic Voice" logo
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

// 2. Onboarding Introduction
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2. Onboarding Introduction'),
        backgroundColor: Colors.transparent, // Transparent AppBar to match Figma
        elevation: 0,
        foregroundColor: Colors.black, // Dark text for AppBar title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_rounded, // Lock icon
                        size: 80,
                        color: warningColor, // Yellowish color for the lock
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '100% Anonymous',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(height: 40, thickness: 2, color: Colors.grey),
                      Text(
                        'Report governance issues safely without revealing your identity. Your privacy is our priority.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/anonymousReportForm');
                        },
                        child: const Text('Next'),
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

// 3. Anonymous Report Form
class AnonymousReportFormScreen extends StatefulWidget {
  const AnonymousReportFormScreen({super.key});

  @override
  State<AnonymousReportFormScreen> createState() => _AnonymousReportFormScreenState();
}

class _AnonymousReportFormScreenState extends State<AnonymousReportFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['Corruption', 'Mismanagement', 'Abuse of Power', 'Other'];
  String _location = 'Tap to select location'; // Placeholder for location

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    // Basic validation
    if (_titleController.text.isEmpty || _selectedCategory == null || _location == 'Tap to select location') {
      _showMessageBox(
        context,
        'Validation Error',
        'Please fill in all required fields (Title, Category, Location).',
      );
      return;
    }
    // In a real app, send data to backend and get a reference code
    // For now, navigate to confirmation screen with a dummy code
    Navigator.of(context).pushNamed(
      '/submissionConfirmation',
      arguments: 'REF-2025-001234', // Dummy reference code
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3. Anonymous Report Form'),
        backgroundColor: Colors.transparent, // Transparent AppBar to match Figma
        elevation: 0,
        foregroundColor: Colors.black, // Dark text for AppBar title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.description, size: 60, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Submit Report',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Report Title',
                      hintText: 'Brief title of the issue',
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: const Text('Select category...'),
                    decoration: const InputDecoration(
                      labelText: 'Category',
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
                  ),
                  const SizedBox(height: 20),
                  // Location field - simplified as text for now
                  GestureDetector(
                    onTap: () {
                      // Implement map selection logic here
                      _showMessageBox(context, 'Location', 'Map selection not implemented yet.');
                      setState(() {
                        _location = 'Kigali City'; // Dummy location after selection
                      });
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Location',
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      child: Text(
                        _location,
                        style: TextStyle(
                          color: _location == 'Tap to select location' ? Colors.grey[700] : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Provide more details about the issue...',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Optional attachment (placeholder)
                  ElevatedButton.icon(
                    onPressed: () {
                      _showMessageBox(context, 'Attachment', 'File attachment not implemented yet.');
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Add Optional Attachment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: primaryColor,
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submitReport,
                    child: const Text('Submit Anonymously'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 4. Submission Confirmation
class SubmissionConfirmationScreen extends StatelessWidget {
  final String referenceCode;
  const SubmissionConfirmationScreen({super.key, required this.referenceCode});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: referenceCode));
    _showMessageBox(context, 'Copied!', 'Reference code copied to clipboard.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4. Submission Confirmation'),
        backgroundColor: Colors.transparent, // Transparent AppBar to match Figma
        elevation: 0,
        foregroundColor: Colors.black, // Dark text for AppBar title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 80,
                    color: successColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Report Submitted!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
                  Text(
                    'Your report has been submitted anonymously',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Reference Code',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _copyToClipboard(context),
                          child: Text(
                            referenceCode,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          'Tap to copy',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _copyToClipboard(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300], // Lighter button for copy
                            foregroundColor: primaryColor,
                          ),
                          child: const Text('Copy Code'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst); // Go back to home/splash
                          },
                          child: const Text('Return Home'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Language selection placeholder
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'English  French', // Placeholder for language selection
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 5. Track Report Status
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
      _showMessageBox(context, 'Input Required', 'Please enter a reference code.');
      return;
    }
    // Simulate fetching status from a backend
    setState(() {
      _currentStatus = 'Under Review'; // Example status
      _lastUpdated = '1 day ago'; // Example update time
    });
    _showMessageBox(context, 'Status Checked', 'Report status updated.');
  }

  @override
  void dispose() {
    _referenceCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5. Track Report Status'),
        backgroundColor: Colors.transparent, // Transparent AppBar to match Figma
        elevation: 0,
        foregroundColor: Colors.black, // Dark text for AppBar title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.track_changes, size: 60, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Track Report',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
                  TextFormField(
                    controller: _referenceCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Reference Code',
                      hintText: 'Enter your reference code',
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _checkStatus,
                    child: const Text('Check Status'),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Status:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              _currentStatus,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: warningColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _currentStatus == 'Under Review' ? 'Under Review' : 'N/A',
                                style: TextStyle(
                                  color: warningColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Submitted: 2 days ago', // Hardcoded as per Figma
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                        ),
                        Text(
                          'Last Updated: $_lastUpdated',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 6. Moderator Login
class ModeratorLoginScreen extends StatefulWidget {
  const ModeratorLoginScreen({super.key});

  @override
  State<ModeratorLoginScreen> createState() => _ModeratorLoginScreenState();
}

class _ModeratorLoginScreenState extends State<ModeratorLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _enable2FA = false;

  void _loginSecurely() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessageBox(context, 'Login Error', 'Please enter email and password.');
      return;
    }
    // Simulate login logic
    if (_emailController.text == 'moderator@gmail.com' && _passwordController.text == 'password') {
      Navigator.of(context).pushReplacementNamed('/moderatorDashboard');
    } else {
      _showMessageBox(context, 'Login Failed', 'Invalid credentials.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('6. Moderator Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.security, size: 60, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Moderator Access',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'moderator@gmail.com',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: '*********',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _enable2FA,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _enable2FA = newValue!;
                          });
                        },
                      ),
                      const Text('Enable 2FA'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _loginSecurely,
                    child: const Text('Login Securely'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 7. Moderator Dashboard
class ModeratorDashboardScreen extends StatelessWidget {
  const ModeratorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('7. Moderator Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.dashboard, size: 60, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Pending Reports',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
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
                          onChanged: (String? newValue) {
                            // Handle category filter change
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: 'All Locations',
                          items: const [
                            DropdownMenuItem(value: 'All Locations', child: Text('All Locations')),
                            DropdownMenuItem(value: 'Kigali', child: Text('Kigali')),
                            DropdownMenuItem(value: 'Butare', child: Text('Butare')),
                          ],
                          onChanged: (String? newValue) {
                            // Handle location filter change
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Example Report Item 1
                  _buildReportItem(
                    context,
                    'Corruption Report',
                    '2 hours ago',
                    'Kigali',
                    'Pending',
                  ),
                  const SizedBox(height: 16),
                  // Example Report Item 2
                  _buildReportItem(
                    context,
                    'Mismanagement Issue',
                    '5 hours ago',
                    'Butare',
                    'Pending',
                  ),
                  // Add more report items dynamically
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, String title, String time, String location, String status) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/moderatorReportDetail');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: warningColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Submitted: $time • $location',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Click to view details',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: primaryColor, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. Moderator Report Detail
class ModeratorReportDetailScreen extends StatelessWidget {
  const ModeratorReportDetailScreen({super.key});

  void _showActionConfirmation(BuildContext context, String action) {
    _showMessageBox(
      context,
      '$action Report',
      'Are you sure you want to $action this report?',
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Go back to dashboard after action
            _showMessageBox(context, 'Success', 'Report $action-ed successfully!');
          },
          child: Text(action, style: TextStyle(color: action == 'Verify' ? successColor : errorColor)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('8. Moderator Report Detail'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.info_outline, size: 60, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Report Details',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
                  // Report details
                  _buildDetailRow(context, 'Title:', 'Corruption in Local Office'),
                  _buildDetailRow(context, 'Category:', 'Corruption'),
                  _buildDetailRow(context, 'Location:', 'Kigali City'),
                  // Add more details as needed (e.g., description, attachments)
                  const SizedBox(height: 30),
                  TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Add verification notes ...',
                      hintText: 'Enter notes here...',
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showActionConfirmation(context, 'Verify'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: successColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Verify'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showActionConfirmation(context, 'Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: errorColor,
                            foregroundColor: Colors.white,
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
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// 9. Public Open Dashboard
class PublicOpenDashboardScreen extends StatelessWidget {
  const PublicOpenDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('9. Public Open Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.public, size: 60, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Public Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
                  // Interactive Heatmap Placeholder
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: primaryColor),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 50, color: primaryColor),
                          SizedBox(height: 10),
                          Text(
                            'Interactive Heatmap',
                            style: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDashboardStat(context, '45', 'Corruption', warningColor),
                      _buildDashboardStat(context, '23', 'Verified', successColor),
                      _buildDashboardStat(context, '12', 'This Week', primaryColor),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/dataPurchase');
                    },
                    child: const Text('Request Data Package'),
                  ),
                  const SizedBox(height: 20),
                  // Language selection placeholder
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'English  French', // Placeholder for language selection
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardStat(BuildContext context, String count, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            count,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// 10. Data Purchase
class DataPurchaseScreen extends StatefulWidget {
  const DataPurchaseScreen({super.key});

  @override
  State<DataPurchaseScreen> createState() => _DataPurchaseScreenState();
}

class _DataPurchaseScreenState extends State<DataPurchaseScreen> {
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _purchaseAndDownload() {
    if (_organizationController.text.isEmpty || _emailController.text.isEmpty) {
      _showMessageBox(context, 'Input Required', 'Please fill in organization and email details.');
      return;
    }
    // Simulate purchase and download logic
    _showMessageBox(
      context,
      'Purchase Successful!',
      'Thank you for your purchase. A download link has been sent to ${_emailController.text}.',
    );
  }

  @override
  void dispose() {
    _organizationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('10. Data Purchase'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.cloud_download, size: 60, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Research Access',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
                  TextFormField(
                    controller: _organizationController,
                    decoration: const InputDecoration(
                      labelText: 'Organization',
                      hintText: 'Research Institute Name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'researcher@instituteedu.com',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Package',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Anonymized CSV export',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
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
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _purchaseAndDownload,
                    child: const Text('Purchase & Download'),
                  ),
                  const SizedBox(height: 20),
                  // Language selection placeholder
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'English  French', // Placeholder for language selection
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 11. Settings / Language & Help
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('11. Settings / Language & Help'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.settings, size: 60, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 40, thickness: 2, color: Colors.grey),
                  _buildSettingsItem(context, Icons.language, 'Language', onTap: () {
                    _showMessageBox(context, 'Language', 'Language selection not implemented.');
                  }),
                  _buildSettingsItem(context, Icons.question_mark_rounded, 'FAQs', onTap: () {
                    _showMessageBox(context, 'FAQs', 'Frequently Asked Questions page coming soon.');
                  }),
                  _buildSettingsItem(context, Icons.contact_support, 'Contact Support', onTap: () {
                    _showMessageBox(context, 'Contact Support', 'Contact details for support.');
                  }),
                  _buildSettingsItem(context, Icons.privacy_tip, 'Privacy Policy', onTap: () {
                    _showMessageBox(context, 'Privacy Policy', 'Privacy Policy content not available.');
                  }),
                  _buildSettingsItem(context, Icons.logout, 'Logout',
                      isLogout: true,
                      onTap: () {
                        _showMessageBox(context, 'Logout', 'You have been logged out.');
                        Navigator.of(context).popUntil((route) => route.isFirst); // Go to splash screen
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, {bool isLogout = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? errorColor : primaryColor,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isLogout ? errorColor : Colors.black87,
              ),
            ),
            const Spacer(),
            if (!isLogout)
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}

// Custom message box function instead of alert()
void _showMessageBox(BuildContext context, String title, String message, {List<Widget>? actions}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: actions ??
            [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
      );
    },
  );
}
