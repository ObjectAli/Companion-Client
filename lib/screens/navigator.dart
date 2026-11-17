import 'package:flutter/material.dart';

import '../widgets/bottom_menu.dart';
import 'feed_screen.dart';
import 'map.dart';
import 'profile.dart';
import 'shedule.dart';
import 'create_event.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const MapScreen(),
    const SheduleScreen(),
    const ProfileScreen(),
  ];

  int _getScreenIndex() {
    switch (_currentIndex) {
      case 0:
        return 0; // Лента
      case 1:
        return 1; // Карта
      case 3:
        return 2; // График
      case 4:
        return 3; // Профиль
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: IndexedStack(index: _getScreenIndex(), children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // Модальное окно создания
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateEventScreen(),
              ),
            ).then((_) {
              if (mounted) setState(() => _currentIndex = 0);
            });
          } else {
            // Переключение вкладок
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}
