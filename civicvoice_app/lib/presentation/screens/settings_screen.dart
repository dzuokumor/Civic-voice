import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/blocs.dart';
import '../../main.dart';
import '../widgets/main_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial || state is AuthUnauthenticated) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildAccountSection(context),
              const SizedBox(height: 16),
              _buildRoleSpecificSection(context),
              const SizedBox(height: 16),
              _buildAppearanceSection(context),
              const SizedBox(height: 16),
              _buildSupportSection(context),
              const SizedBox(height: 24),
              _buildAuthSection(context),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'CivicVoice v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('AuthBloc state in Settings: ${state.runtimeType}');
        if (state is AuthAuthenticated) {
          print('AuthAuthenticated - Role: ${state.role}, Email: ${state.email}');
        } else if (state is AuthSuccess) {
          print('AuthSuccess - Role: ${state.role}');
        } else {
          print('Not authenticated: $state');
        }

        if (state is AuthAuthenticated) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${state.role.toUpperCase()} Account',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Signed In',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is AuthSuccess) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Authenticated User',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${state.role.toUpperCase()} Account',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Signed In',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Guest User',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Limited access • Sign in for full features',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildRoleSpecificSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? userRole;

        if (state is AuthAuthenticated) {
          userRole = state.role;
        } else if (state is AuthSuccess) {
          userRole = state.role;
        }

        if (userRole == null) return const SizedBox.shrink();

        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        userRole == 'moderator' ? Icons.admin_panel_settings : Icons.science,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${userRole.toUpperCase()} TOOLS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (userRole == 'moderator') ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.dashboard,
                      color: Colors.orange,
                    ),
                  ),
                  title: const Text('Moderator Dashboard'),
                  subtitle: const Text('Review and manage reports'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.moderatorDashboard),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: Colors.purple,
                    ),
                  ),
                  title: const Text('Report Management'),
                  subtitle: const Text('Detailed report moderation'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.moderatorDashboard),
                ),
              ] else if (userRole == 'researcher') ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.download,
                      color: Colors.blue,
                    ),
                  ),
                  title: const Text('Data Export'),
                  subtitle: const Text('Purchase and download research data'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dataPurchase),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme'),
            subtitle: const Text('System Default'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings coming soon')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHelpDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated || state is AuthSuccess) {
          return Column(
            children: [
              FilledButton.icon(
                onPressed: () => _showLogoutConfirmation(context),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  minimumSize: const Size(double.infinity, 48),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                icon: const Icon(Icons.person_add),
                label: const Text('Create Account'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                icon: const Icon(Icons.login),
                label: const Text('Sign In'),
              ),
            ],
          );
        }
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.read<LanguageBloc>().add(ChangeLanguageEvent(const Locale('en', 'US')));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Français'),
              onTap: () {
                context.read<LanguageBloc>().add(ChangeLanguageEvent(const Locale('fr', 'FR')));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('Light')),
            ListTile(title: Text('Dark')),
            ListTile(title: Text('System Default')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const SingleChildScrollView(
          child: Text(
            'CivicVoice is a platform for anonymous governance reporting.\n\n'
                'How to use:\n'
                '• Submit reports anonymously\n'
                '• Track your reports with reference codes\n'
                '• Browse verified public reports\n\n'
                'For technical support, contact: support@civicvoice.app',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'CivicVoice Privacy Policy\n\n'
                'We are committed to protecting your privacy and ensuring the anonymity of your reports.\n\n'
                'Data Collection:\n'
                '• Reports are collected anonymously\n'
                '• No personally identifiable information is required\n'
                '• Location data is optional and generalized\n\n'
                'Data Usage:\n'
                '• Reports are used for governance transparency\n'
                '• Anonymized data may be used for research\n'
                '• Data is never sold to third parties\n\n'
                'Data Security:\n'
                '• All data is encrypted in transit and at rest\n'
                '• Access is restricted to authorized personnel\n'
                '• Regular security audits are conducted\n\n'
                'For full privacy policy, visit: civicvoice.app/privacy',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About CivicVoice'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CivicVoice v1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'A secure platform for anonymous governance reporting and transparency.',
              ),
              SizedBox(height: 16),
              Text(
                'Features:\n'
                    '• Anonymous report submission\n'
                    '• Real-time status tracking\n'
                    '• Professional moderation\n'
                    '• Public transparency dashboard\n'
                    '• Research data access',
              ),
              SizedBox(height: 16),
              Text(
                'Built with Flutter and powered by a secure backend infrastructure.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}