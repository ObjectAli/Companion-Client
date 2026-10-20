import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Убираем SafeArea, чтобы градиент был под статус-баром
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // 2. Используем ConstrainedBox, чтобы растянуть контент на всю высоту
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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

                        // 3. SPACER прижимает "Log Out" к низу, если есть свободное место
                        const Spacer(),

                        // --- 4. КНОПКА ВЫХОДА ---
                        _buildLogoutButton(context),

                        const SizedBox(height: 30), // Отступ от низа экрана
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ==================== ВИДЖЕТЫ ====================

  /// Шапка с градиентом, аватаром и именем
  Widget _buildHeader() {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryPurple, AppColors.primaryBlue],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Декоративные круги на фоне (для стиля)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlackSea.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withOpacity(0.1),
              ),
            ),
          ),

          // Контент шапки
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Аватар
              Container(
                padding: const EdgeInsets.all(4), //Обводка
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlackSea,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 85,
                  backgroundColor: Color(0xFFE0E0E0), // Светло-серый фон
                  child: Icon(
                    Icons.person,
                    size: 90, // Размер иконки
                    color: AppColors.primaryBlackSea, // Темно-синий цвет иконки
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Имя
              const Text(
                'Alex Rivers',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white, // Темно-синий
                ),
              ),
              const SizedBox(height: 5),

              // Бейдж "Premium-подписка"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color: Color.fromARGB(255, 231, 209, 3),
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Premium',
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 231, 209, 3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Блок со статистикой (24, 128, 12k)
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('24', 'Организовал'),
          _buildVerticalDivider(),
          _buildStatItem('128', 'Принял'),
          _buildVerticalDivider(),
          _buildStatItem('12', 'Звёзд'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1B4D),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade300);
  }

  /// Список настроек (My Interests, Account Settings...)
  Widget _buildSettingsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _buildSettingRow(
            context: context,
            title: 'Мои интересы',
            onTap: () {
              Navigator.pushNamed(context, '/interests');
            },
          ),
          const SizedBox(height: 10),
          _buildSettingRow(
            context: context,
            title: 'Мои мероприятия',
            onTap: () {
              Navigator.pushNamed(context, '/my_events'); // <--- Свой переход
            },
          ),
          const SizedBox(height: 10),
          _buildSettingRow(
            context: context,
            title: 'Настройки аккаунта',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/account_settings',
              ); // <--- Свой переход
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required BuildContext context,
    required String title,
    required VoidCallback onTap, // <--- Колбэк для перехода
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1B4D),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primaryBlackSea,
            ),
          ],
        ),
      ),
    );
  }

  /// Кнопка выхода (Log Out)
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: () {
          // TODO: Логика выхода
        },
        borderRadius: BorderRadius.circular(12),
        child:
            // Текст
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Переход на восстановление пароля
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlackSea,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Выход',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
