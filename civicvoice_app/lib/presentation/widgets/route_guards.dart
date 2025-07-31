import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/domain/blocs.dart';
import '/main.dart';

class RouteGuards {
  /// Requires user to be authenticated (any role)
  static Widget requireAuth(WidgetBuilder builder) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated || state is AuthSuccess) {
          return builder(context);
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  /// Requires user to be a researcher
  static Widget requireResearcher(WidgetBuilder builder) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated && state.role == 'researcher') {
          return builder(context);
        } else if (state is AuthSuccess && state.role == 'researcher') {
          return builder(context);
        } else if (state is AuthAuthenticated || state is AuthSuccess) {
          return _buildAccessDenied(context, 'researcher');
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please sign in as a researcher to access this feature'),
                backgroundColor: Colors.orange,
              ),
            );
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  static Widget requireModerator(WidgetBuilder builder) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated && state.role == 'moderator') {
          return builder(context);
        } else if (state is AuthSuccess && state.role == 'moderator') {
          return builder(context);
        } else if (state is AuthAuthenticated || state is AuthSuccess) {
          return _buildAccessDenied(context, 'moderator');
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please sign in as a moderator to access this feature'),
                backgroundColor: Colors.red,
              ),
            );
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  static Widget buildDataPurchaseOption(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isResearcher = false;

        if (state is AuthAuthenticated && state.role == 'researcher') {
          isResearcher = true;
        } else if (state is AuthSuccess && state.role == 'researcher') {
          isResearcher = true;
        }

        if (isResearcher) {
          return Card(
            child: ListTile(
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
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  static Widget _buildAccessDenied(BuildContext context, String requiredRole) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 24),
              Text(
                'Access Restricted',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This feature requires a $requiredRole account.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please contact an administrator or create a $requiredRole account.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.home),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}