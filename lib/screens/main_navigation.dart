import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:project001/screens/home_screen.dart';
import 'package:project001/screens/learn_screen.dart';
import 'package:project001/screens/alerts_screen.dart';
import 'package:project001/screens/chat_screen.dart';
import 'package:project001/screens/profile_screen.dart';
import 'package:project001/theme/app_theme.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LearnScreen(),
    AlertsScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.textSecondary,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.bookOpen),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.bell),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
