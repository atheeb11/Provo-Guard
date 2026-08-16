import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class DashboardShell extends StatefulWidget {
  final Widget child;
  const DashboardShell({super.key, required this.child});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  DateTime? _lastBackPressTime;

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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // 1. If on sub-tabs, navigate back to main Home Dashboard tab first
        if (selectedIndex != 0) {
          context.go('/dashboard');
          return;
        }

        // 2. If on main Home Dashboard tab, show confirmation toast before exiting
        final now = DateTime.now();
        if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit Provo Guard', style: TextStyle(color: Colors.white)),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF0A2540),
            ),
          );
        } else {
          // User pressed back twice within 2 seconds: close app cleanly
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: widget.child,
        floatingActionButton: SizedBox(
          width: 52,
          height: 52,
          child: FloatingActionButton(
            onPressed: () => context.push('/emergency'),
            backgroundColor: AppColors.riskCritical,
            elevation: 6,
            shape: const CircleBorder(),
            tooltip: 'Trigger SOS Emergency Alert',
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 16),
                Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
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
      ),
    );
  }
}

