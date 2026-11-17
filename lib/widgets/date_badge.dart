import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../models/event_model.dart';

class DateBadge extends StatelessWidget {
  final EventModel event;

  const DateBadge({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryBlackSea,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- ВЕРХНЯЯ ЧАСТЬ: Дата ---
          Text(
            event.formattedDate.split(' ')[0], // День (например "21")
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            event.formattedDate.split(' ')[1], // Месяц (например "ИЮН")
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          // --- ЦЕНТР: Горизонтальная белая линия ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(height: 1.5, width: 30, color: Colors.white),
          ),

          //--- НИЖНЯЯ ЧАСТЬ: Время ---
          Text(
            event.formattedTime, // Например "19:30"
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
