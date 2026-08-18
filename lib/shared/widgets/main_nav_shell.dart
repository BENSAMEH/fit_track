import 'package:fit_track/features/health/presentation/health_screen.dart';
import 'package:fit_track/features/history/presentation/history_screen.dart';
import 'package:fit_track/features/profile/presentation/profile_screen.dart';
import 'package:fit_track/features/progress/presentation/screens/progress_screen.dart';
import 'package:flutter/material.dart';


import '../../features/home/presentation/screens/home_screen.dart';

import 'app_bottom_nav_bar.dart';

/// Hosts the 5 main tabs + persistent bottom nav bar.
/// This is what '/home' should route to, not HomeScreen directly.
class MainNavShell extends StatefulWidget {
  const MainNavShell({super.key});

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  int _currentIndex = 0;

  // IndexedStack keeps all tabs alive (preserves scroll position,
  // form state, etc.) instead of rebuilding on every tab switch.
  final _screens = const [
    HomeScreen(),
    HistoryScreen(),
    ProgressScreen(),
    HealthScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}