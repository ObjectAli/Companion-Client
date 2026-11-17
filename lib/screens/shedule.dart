import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_config.dart';

class SheduleScreen extends StatelessWidget {
  const SheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, size: 80, color: AppColors.primaryBlue.withOpacity(0.5)),
              const SizedBox(height: 16),
              const Text('Расписание моих мероприятий', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBlackSea)),
              const SizedBox(height: 8),
              const Text('Здесь будет расписание', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}