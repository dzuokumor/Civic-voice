import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '/domain/blocs.dart';

class TrackReportStatusScreen extends StatefulWidget {
  final Map<String, dynamic>? initialCredentials;

  const TrackReportStatusScreen({
    super.key,
    this.initialCredentials,
  });

  @override
  State<TrackReportStatusScreen> createState() => _TrackReportStatusScreenState();
}

class _TrackReportStatusScreenState extends State<TrackReportStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _referenceCodeController = TextEditingController();
  final _passphraseController = TextEditingController();

  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCredentials != null) {
      _referenceCodeController.text = widget.initialCredentials!['referenceCode'] ?? '';
      _passphraseController.text = widget.initialCredentials!['passphrase'] ?? '';

      if (_referenceCodeController.text.isNotEmpty && _passphraseController.text.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _trackReport();
        });
      }
    }
  }

  @override
  void dispose() {
    _referenceCodeController.dispose();
    _passphraseController.dispose();
    super.dispose();
  }

  void _trackReport() {
    if (_formKey.currentState!.validate()) {
      setState(() => _hasSearched = true);
      context.read<ReportBloc>().add(TrackReportEvent(
        _referenceCodeController.text.trim().toUpperCase(),
        _passphraseController.text.trim(),
      ));
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '⏳';
      case 'verified':
        return '✅';
      case 'rejected':
        return '❌';
      default:
        return '📋';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'verified':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Your report is being reviewed by our moderation team.';
      case 'verified':
        return 'Your report has been verified and published to the public dashboard.';
      case 'rejected':
        return 'Your report did not meet our verification criteria.';
      default:
        return 'Report status unknown.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildTrackingForm(context, state),
                const SizedBox(height: 32),
                if (state is ReportTracked) ...[
                  _buildReportDetails(context, state),
                  const SizedBox(height: 24),
                  _buildStatusTimeline(context, state),
                ] else if (state is ReportLoading && _hasSearched) ...[
                  _buildLoadingState(context),
                ] else if (_hasSearched) ...[
                  _buildEmptyState(context),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.track_changes,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Track Your Report',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your credentials to check the status of your anonymous report.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingForm(BuildContext context, ReportState state) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _referenceCodeController,
            decoration: const InputDecoration(
              labelText: 'Reference Code',
              hintText: 'Enter your 8-character reference code',
              prefixIcon: Icon(Icons.tag),
            ),
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Please enter your reference code';
              }
              if (value!.length != 8) {
                return 'Reference code must be 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passphraseController,
            decoration: const InputDecoration(
              labelText: 'Passphrase',
              hintText: 'Enter your passphrase',
              prefixIcon: Icon(Icons.key),
            ),
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Please enter your passphrase';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: state is ReportLoading ? null : _trackReport,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: state is ReportLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text('Track Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDetails(BuildContext context, ReportTracked state) {
    final report = state.report;
    final submittedDate = DateTime.parse(report['submitted_at']);
    final lastUpdated = DateTime.parse(report['last_updated']);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _getStatusIcon(report['status']),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status: ${report['status'].toString().toUpperCase()}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(report['status']),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusMessage(report['status']),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              'Report Title',
              report['title'],
              Icons.title,
            ),
            _buildDetailRow(
              context,
              'Category',
              report['category'].toString().replaceAll('_', ' ').toUpperCase(),
              Icons.category,
            ),
            _buildDetailRow(
              context,
              'Submitted',
              DateFormat('MMM dd, yyyy • HH:mm').format(submittedDate),
              Icons.calendar_today,
            ),
            _buildDetailRow(
              context,
              'Last Updated',
              DateFormat('MMM dd, yyyy • HH:mm').format(lastUpdated),
              Icons.update,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, ReportTracked state) {
    final statusHistory = state.statusHistory;

    if (statusHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statusHistory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final log = statusHistory[index];
                final timestamp = DateTime.parse(log['timestamp']);

                return _StatusTimelineItem(
                  action: log['action'],
                  notes: log['notes'],
                  timestamp: timestamp,
                  isLatest: index == 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Checking report status...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No report found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your credentials and try again.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tracking Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🔍 How to Track',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Enter both your reference code and passphrase exactly as provided when you submitted your report.'),
              SizedBox(height: 16),
              Text(
                '📱 Report Status Types',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Pending: Being reviewed\n• Verified: Approved and published\n• Rejected: Did not meet criteria'),
              SizedBox(height: 16),
              Text(
                '❓ Can\'t Find Your Report?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Double-check your credentials. Reports are typically reviewed within 24-48 hours.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _StatusTimelineItem extends StatelessWidget {
  final String action;
  final String? notes;
  final DateTime timestamp;
  final bool isLatest;

  const _StatusTimelineItem({
    required this.action,
    this.notes,
    required this.timestamp,
    this.isLatest = false,
  });

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'verified':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'submitted':
        return Icons.send;
      default:
        return Icons.info;
    }
  }

  Color _getActionColor(BuildContext context, String action) {
    switch (action.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'submitted':
        return Theme.of(context).colorScheme.primary;
      default:
        return Colors.grey;
    }
  }

  String _formatAction(String action) {
    return action.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getActionColor(context, action),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getActionIcon(action),
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _formatAction(action),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isLatest) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Latest',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM dd, yyyy • HH:mm').format(timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              if (notes != null && notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    notes!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}