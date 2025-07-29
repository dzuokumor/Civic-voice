import 'package:flutter/material.dart';
import 'main.dart';

class PublicOpenDashboardScreen extends StatefulWidget {
  const PublicOpenDashboardScreen({super.key});

  @override
  State<PublicOpenDashboardScreen> createState() => _PublicOpenDashboardScreenState();
}

class _PublicOpenDashboardScreenState extends State<PublicOpenDashboardScreen> {
  // Simulated verified reports data
  List<Map<String, dynamic>> reports = [
    {
      'title': 'Corruption in Local Office',
      'category': 'Corruption',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'region': 'Kigali',
      'verified': true,
    },
    {
      'title': 'Abuse of Power',
      'category': 'Abuse of Power',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'region': 'Eastern',
      'verified': true,
    },
    {
      'title': 'Mismanagement of Funds',
      'category': 'Mismanagement',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'region': 'Northern',
      'verified': true,
    },
  ];

  String? selectedCategory;
  String? selectedRegion;
  DateTimeRange? selectedDateRange;

  List<String> get categories => [
    'All',
    ...{for (var r in reports) r['category'] as String}
  ];
  List<String> get regions => [
    'All',
    ...{for (var r in reports) r['region'] as String}
  ];

  List<Map<String, dynamic>> get filteredReports {
    return reports.where((report) {
      if (selectedCategory != null && selectedCategory != 'All' && report['category'] != selectedCategory) return false;
      if (selectedRegion != null && selectedRegion != 'All' && report['region'] != selectedRegion) return false;
      if (selectedDateRange != null) {
        final date = report['date'] as DateTime;
        if (date.isBefore(selectedDateRange!.start) || date.isAfter(selectedDateRange!.end)) return false;
      }
      return report['verified'] == true;
    }).toList();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigation(
      currentIndex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Public Dashboard',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCategory ?? 'All',
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (val) => setState(() => selectedCategory = val),
                    isExpanded: true,
                    hint: const Text('Category'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedRegion ?? 'All',
                    items: regions.map((reg) => DropdownMenuItem(value: reg, child: Text(reg))).toList(),
                    onChanged: (val) => setState(() => selectedRegion = val),
                    isExpanded: true,
                    hint: const Text('Region'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(selectedDateRange == null ? 'Date' : '${selectedDateRange!.start.month}/${selectedDateRange!.start.day} - ${selectedDateRange!.end.month}/${selectedDateRange!.end.day}'),
                  onPressed: _pickDateRange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredReports.isEmpty
                  ? const Center(child: Text('No verified reports found.'))
                  : ListView.builder(
                      itemCount: filteredReports.length,
                      itemBuilder: (context, idx) {
                        final report = filteredReports[idx];
                        return Card(
                          child: ListTile(
                            title: Text(report['title']),
                            subtitle: Text('${report['category']} • ${report['region']} • ${report['date'].toLocal().toString().split(' ')[0]}'),
                            trailing: const Icon(Icons.verified, color: Colors.green),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
