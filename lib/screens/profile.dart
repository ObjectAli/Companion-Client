import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/app_colors.dart';
import '../widgets/bottom_menu.dart';

import 'dart:ui';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. ОСНОВНОЙ КОНТЕНТ
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // --- 1. ШАПКА ПРОФИЛЯ ---
                              _buildHeader(),

                              const SizedBox(height: 20),

                              // --- 2. СТАТИСТИКА ---
                              _buildStats(),

                              const SizedBox(height: 20),

                              // --- 3. СПИСОК НАСТРОЕК ---
                              _buildSettingsList(context),

                              // Отступ снизу, чтобы последний элемент не прятался за меню
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 2. ПАРЯЩЕЕ МЕНЮ
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth),
                child: BottomNavBar(
                  currentIndex: 4, // Индекс "Профиль" (5-я вкладка)
                  onTap: (index) {
                    if (index == 4) return;
                    final route = BottomNavBar.items[index]['route'] as String;
                    Navigator.pushNamed(context, route);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ВИДЖЕТЫ ====================

  Widget _buildHeader() {
    return Container(
      height: 240, // Чуть больше по высоте, как вы просили
      decoration: const BoxDecoration(
        // Оставляем градиент как фон
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlackSea, AppColors.primaryBlue],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // 1. Декоративные круги на фоне (чтобы стекло было заметнее)
          Positioned(
            top: -40,
            right: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: 40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
              ),
            ),
          ),

          // 2. Стеклянная карточка
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ), // Сила размытия
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.15,
                      ), // Полупрозрачный белый
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.2,
                        ), // Тонкая светлая рамка
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // --- ЛЕВАЯ ЧАСТЬ: Аватар ---
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xFFE0E0E0),
                            child: Icon(
                              Icons.person,
                              size: 45,
                              color: AppColors.primaryBlackSea,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // --- ЦЕНТР: Имя и статус ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Али Норбобаев',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines:
                                    2, // <--- РАЗРЕШАЕМ ПЕРЕНОС НА 2 СТРОКИ
                                overflow: TextOverflow
                                    .ellipsis, // Если не влезет даже в 2 строки
                              ),
                              const SizedBox(height: 6),
                              // Бейдж Premium
                              Row(
                                children: [
                                  const Icon(
                                    Icons.workspace_premium,
                                    color: AppColors.yellow,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Премиум',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // --- ПРАВАЯ ЧАСТЬ: Кнопка редактирования ---
                        IconButton(
                          onPressed: () {
                            // TODO: Переход на редактирование профиля
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Блок со статистикой (24, 10, 5)
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _buildStatItem('24', 'Провёл')),
          _buildVerticalDivider(),
          Expanded(child: _buildStatItem('10', 'Посетил')),
          _buildVerticalDivider(),
          Expanded(child: _buildStatItem('5', 'Звёзд')),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlackSea,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade300);
  }

  /// Список настроек — теперь в виде карточек, как в ленте
  Widget _buildSettingsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildSettingCard(
            context: context,
            title: 'Мои интересы',
            icon: Icons.favorite_border,
            onTap: () => Navigator.pushNamed(context, '/interests'),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            context: context,
            title: 'Мои мероприятия',
            icon: Icons.event_note_outlined,
            onTap: () => Navigator.pushNamed(context, '/my_events'),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            context: context,
            title: 'Настройки аккаунта',
            icon: Icons.settings_outlined,
            onTap: () => Navigator.pushNamed(context, '/account_settings'),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            context: context,
            title: 'Выход',
            icon: Icons.logout,
            isDestructive: true, // Красный цвет для выхода
            onTap: () => Navigator.pushNamed(context, '/logout'),
          ),
        ],
      ),
    );
  }

  /// Карточка одного пункта меню
  Widget _buildSettingCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColors.burgundi
        : AppColors.primaryBlackSea;
    final bgColor = isDestructive
        ? AppColors.burgundi.withValues(alpha: 0.08)
        : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive
                ? AppColors.burgundi.withValues(alpha: 0.2)
                : const Color(0xFFE0E0E0),
            width: 1,
          ),
          boxShadow: isDestructive
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Иконка
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),

            // Текст
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),

            // Стрелка
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: color.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
