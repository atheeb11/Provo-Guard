import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class DashboardShell extends StatelessWidget {
  final Widget child;
  const DashboardShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard/ai-chat')) return 1;
    if (location.startsWith('/dashboard/analyze')) return 2;
    if (location.startsWith('/dashboard/alerts')) return 3;
    if (location.startsWith('/dashboard/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/dashboard/ai-chat');
        break;
      case 2:
        context.go('/dashboard/analyze');
        break;
      case 3:
        context.go('/dashboard/alerts');
        break;
      case 4:
        context.go('/dashboard/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/emergency'),
        backgroundColor: AppColors.riskCritical,
        elevation: 4,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        label: const Text('EMERGENCY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              activeIcon: Icon(Icons.grid_view_rounded, color: AppColors.primaryRoyalBlue),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_outlined),
              activeIcon: Icon(Icons.psychology_rounded, color: AppColors.primaryRoyalBlue),
              label: 'AI Assistant',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.search_rounded, color: AppColors.primaryRoyalBlue),
              label: 'Analyze',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded),
              activeIcon: Icon(Icons.notifications_rounded, color: AppColors.primaryRoyalBlue),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded, color: AppColors.primaryRoyalBlue),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
