import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/blocs.dart';

class ModeratorReportDetailScreen extends StatefulWidget {
  final String reportId;

  const ModeratorReportDetailScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<ModeratorReportDetailScreen> createState() => _ModeratorReportDetailScreenState();
}

class _ModeratorReportDetailScreenState extends State<ModeratorReportDetailScreen> {
  final _notesController = TextEditingController();
  Map<String, dynamic>? _reportData;

  @override
  void initState() {
    super.initState();
    _loadReportDetails();
  }

  void _loadReportDetails() {
    setState(() {
      _reportData = {
        'id': widget.reportId,
        'title': 'Corruption in Local Office',
        'category': 'corruption',
        'description': 'Detailed description of corruption activities observed in the local government office...',
        'location': 'Kigali City',
        'language': 'en',
        'status': 'pending',
        'created_at': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'has_attachment': true,
      };
    });
  }

  void _moderateReport(String action) {
    if (_reportData == null) return;

    context.read<ReportBloc>().add(ModerateReportEvent(
      reportId: widget.reportId,
      action: action,
      notes: _notesController.text.trim(),
    ));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportModerationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is ReportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          title: Text('Report #${widget.reportId.substring(0, 8)}'),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: _reportData == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Title', _reportData!['title']),
                      _buildDetailRow('Category', _reportData!['category'].toString().toUpperCase()),
                      _buildDetailRow('Location', _reportData!['location']),
                      _buildDetailRow('Language', _reportData!['language'].toString().toUpperCase()),
                      _buildDetailRow('Status', _reportData!['status'].toString().toUpperCase()),
                      _buildDetailRow('Submitted', _formatDateTime(_reportData!['created_at'])),
                      if (_reportData!['has_attachment'] == true)
                        _buildDetailRow('Attachment', 'File available for review'),
                      const SizedBox(height: 16),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          _reportData!['description'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Moderation Actions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _notesController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Add verification notes...',
                          hintText: 'Provide detailed reasoning for your decision',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<ReportBloc, ReportState>(
                        builder: (context, state) {
                          final isLoading = state is ReportLoading;

                          return Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.check),
                                  label: const Text('Verify Report'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: isLoading ? null : () => _moderateReport('verified'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Reject Report'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: isLoading ? null : () => _moderateReport('rejected'),
                                ),
                              ),
                            ],
                          );
                        },
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}