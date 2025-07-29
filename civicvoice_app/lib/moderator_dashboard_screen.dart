import 'package:flutter/material.dart';

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
                  MaterialPageRoute(builder: (_) => const ModeratorDashboardScreen()),
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
                  MaterialPageRoute(builder: (_) => const ModeratorDashboardScreen()),
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
