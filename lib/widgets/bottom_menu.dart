import 'package:flutter/material.dart';

import '../config/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<Map<String, dynamic>> items = [
    {
      'icon': Icons.format_list_bulleted_outlined,
      'activeIcon': Icons.format_list_bulleted,
      'label': 'Лента',
    },
    {'icon': Icons.place_outlined, 'activeIcon': Icons.place, 'label': 'Карта'},
    {'icon': Icons.add, 'activeIcon': Icons.add, 'label': 'Создать'},
    {
      'icon': Icons.calendar_month_outlined,
      'activeIcon': Icons.calendar_month,
      'label': 'График',
    },
    {
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
      'label': 'Профиль',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter, // <--- Прижимаем к низу
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
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
        ),
      ),
    );
  }
}
