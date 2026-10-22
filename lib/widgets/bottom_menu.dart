import 'package:flutter/material.dart';

import '../config/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  /// Текущий выбранный индекс (0..3)
  final int currentIndex;

  /// Колбэк при нажатии на вкладку
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Список вкладок: иконка, активная иконка, подпись, маршрут
  static const List<Map<String, dynamic>> items = [
    {
      'icon': Icons.format_list_bulleted_outlined,
      'activeIcon': Icons.format_list_bulleted,
      'label': 'Лента',
      'route': '/feed',
    },
    {
      'icon': Icons.place_outlined,
      'activeIcon': Icons.place,
      'label': 'Карта',
      'route': '/map',
    },
    {
      'icon': Icons.add,
      'activeIcon': Icons.add,
      'label': 'Создать',
      'route': '/create',
    },
    {
      'icon': Icons.calendar_month_outlined,
      'activeIcon': Icons.calendar_month,
      'label': 'График',
      'route': '/my',
    },
    {
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
      'label': 'Профиль',
      'route': '/profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.only(left:25, right: 25, bottom: 16),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.5), // Мягкая тень
              blurRadius: 20, // Небольшое размытие
              offset: const Offset(0, 5), // Смещение чуть ниже панели
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            final isSelected = currentIndex == index;
            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlue.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? items[index]['activeIcon'] as IconData
                          : items[index]['icon'] as IconData,
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
