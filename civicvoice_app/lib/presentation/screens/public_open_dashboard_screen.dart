import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/blocs.dart';
import '../widgets/main_navigation.dart';

class PublicOpenDashboardScreen extends StatefulWidget {
  const PublicOpenDashboardScreen({super.key});

  @override
  State<PublicOpenDashboardScreen> createState() => _PublicOpenDashboardScreenState();
}

class _PublicOpenDashboardScreenState extends State<PublicOpenDashboardScreen> {
  String? selectedCategory;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    String? startDate;
    String? endDate;

    if (selectedDateRange != null) {
      startDate = selectedDateRange!.start.toIso8601String();
      endDate = selectedDateRange!.end.toIso8601String();
    }

    context.read<ReportBloc>().add(LoadPublicReportsEvent(
      category: selectedCategory,
      startDate: startDate,
      endDate: endDate,
    ));
  }

  void _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: selectedDateRange,
    );
    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _loadReports();
    }
  }

  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedDateRange = null;
    });
    _loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Public Reports'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadReports,
            ),
            if (selectedCategory != null || selectedDateRange != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearFilters,
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verified Reports',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Browse publicly available verified reports',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(selectedCategory ?? 'All Categories'),
                      selected: selectedCategory != null,
                      onSelected: (selected) {
                        _showCategoryFilter();
                      },
                      avatar: const Icon(Icons.category, size: 16),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(
                          selectedDateRange == null
                              ? 'All Dates'
                              : '${selectedDateRange!.start.month}/${selectedDateRange!.start.day} - ${selectedDateRange!.end.month}/${selectedDateRange!.end.day}'
                      ),
                      selected: selectedDateRange != null,
                      onSelected: (selected) => _pickDateRange(),
                      avatar: const Icon(Icons.date_range, size: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    if (state is ReportLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PublicReportsLoaded) {
                      if (state.reports.isEmpty) {
                        return _buildEmptyState();
                      }

                      return RefreshIndicator(
                        onRefresh: () async => _loadReports(),
                        child: ListView.builder(
                          itemCount: state.reports.length,
                          itemBuilder: (context, index) {
                            final report = state.reports[index];
                            return _buildReportCard(report);
                          },
                        ),
                      );
                    } else if (state is ReportFailure) {
                      return _buildErrorState(state.message);
                    }

                    return _buildEmptyState();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final createdAt = DateTime.parse(report['created_at']);
    final timeAgo = _getTimeAgo(createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showReportDetails(report),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      report['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.green.shade700,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                report['description'] ?? 'No description available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    _formatCategory(report['category']),
                    Icons.category,
                    Theme.of(context).colorScheme.primary,
                  ),
                  _buildInfoChip(
                    timeAgo,
                    Icons.access_time,
                    Colors.grey.shade600,
                  ),
                  _buildInfoChip(
                    report['language'].toString().toUpperCase(),
                    Icons.language,
                    Colors.orange.shade600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No verified reports found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or check back later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading reports',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadReports,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Select Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...['corruption', 'infrastructure', 'healthcare', 'education', 'environment', 'public_safety', 'transportation', 'housing', 'employment', 'other']
                .map((category) => ListTile(
              leading: Icon(
                _getCategoryIcon(category),
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(_formatCategory(category)),
              onTap: () {
                setState(() => selectedCategory = category);
                Navigator.pop(context);
                _loadReports();
              },
            )),
            ListTile(
              leading: Icon(
                Icons.clear_all,
                color: Colors.grey.shade600,
              ),
              title: const Text('All Categories'),
              onTap: () {
                setState(() => selectedCategory = null);
                Navigator.pop(context);
                _loadReports();
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'corruption':
        return Icons.gavel;
      case 'infrastructure':
        return Icons.construction;
      case 'healthcare':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'environment':
        return Icons.eco;
      case 'public_safety':
        return Icons.security;
      case 'transportation':
        return Icons.directions_bus;
      case 'housing':
        return Icons.home;
      case 'employment':
        return Icons.work;
      default:
        return Icons.report_problem;
    }
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    report['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'VERIFIED REPORT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Category', _formatCategory(report['category'])),
                    _buildDetailRow('Submitted', _formatDate(report['created_at'])),
                    _buildDetailRow('Language', report['language'].toString().toUpperCase()),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report['description'] ?? 'No description provided',
                      style: const TextStyle(fontSize: 14, height: 1.5),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatCategory(String category) {
    return category.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }
}