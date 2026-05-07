import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const DashboardScreen(), 
    const StatisticsScreen(),
    const SettingsScreen()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Row(
        children: [
          Icon(
            Icons.spa,
            color: const Color.fromRGBO(77, 182, 172, 1),
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text(
            'Aura Flow',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(77, 182, 172, 1),
            ),
          ),
        ],
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.white, 
      foregroundColor: Color.fromRGBO(77, 182, 172, 2),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        backgroundColor: Colors.white,
        indicatorColor: Color.fromRGBO(77, 182, 172, 0.3),
        indicatorShape: CircleBorder(),
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: '', ),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: ''),
        ],
      ),
    );
  }
}


