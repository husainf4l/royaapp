import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:royaapp/widgets/custom_app_bar.dart';
import 'package:royaapp/screens/home_screen.dart';
import 'package:royaapp/screens/live_view_screen.dart';
import 'package:royaapp/screens/smart_replay_screen.dart';
import 'package:royaapp/screens/ai_commentator_settings_screen.dart';
import 'package:royaapp/screens/tactical_analysis_screen.dart';
import 'package:royaapp/screens/profile_screen.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const LiveViewScreen(),
    const SmartReplayScreen(),
    const AICommentatorSettingsScreen(),
    const TacticalAnalysisScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.tv), label: ''),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_2_circlepath),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.lab_flask),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: ''),
        ],
      ),
    );
  }
}
