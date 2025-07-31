import 'package:flutter/material.dart';
import '../../main.dart';

class MainNavigation extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const MainNavigation({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            selectedFontSize: 12,
            unselectedFontSize: 10,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.home_outlined, Icons.home, 0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.report_outlined, Icons.report, 1),
                label: 'Report',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.track_changes_outlined, Icons.track_changes, 2),
                label: 'Track',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.view_list_outlined, Icons.view_list, 3),
                label: 'Reports',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.settings_outlined, Icons.settings, 4),
                label: 'Settings',
              ),
            ],
            onTap: (index) => _onNavTap(context, index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData outlinedIcon, IconData filledIcon, int index) {
    final isSelected = currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isSelected ? filledIcon : outlinedIcon,
        size: 24,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.reportForm);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.trackStatus);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.publicDashboard);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.settings);
        break;
    }
  }
}