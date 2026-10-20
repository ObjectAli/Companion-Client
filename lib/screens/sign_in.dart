import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_config.dart';

import '../models/login_model.dart';
import '../config/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // 1. Ограничиваем максимальную ширину ВСЕГО контента (для планшетов)
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConfig.maxWidth, // 2. МАКСИМАЛЬНАЯ ШИРИНА
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // --- ВЕРХНЯЯ ЧАСТЬ С КАРТИНКОЙ ---
                            // Желтый контейнер с картинкой
                            Container(
                              width: double
                                  .infinity, // <--- Растягиваем на всю ширину
                              height:
                                  constraints.maxHeight *
                                  0.35, // Занимает 35% высоты экрана
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                child: Image.asset(
                                  '../assets/images/welcome.jpeg', // <--- ВСТАВЬТЕ СЮДА ВАШ ФАЙЛ
                                  fit: BoxFit.cover, // Растягиваем картинку, чтобы заполнить область
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                            ),

                            // --- ФОРМА (ОБЕРНУТА В PADDING) ---
                            Expanded(
                              // 2. ДОБАВЛЯЕМ PADDING ЗДЕСЬ, чтобы отступы были только у формы
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 10.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch, // Растягиваем элементы формы внутри Padding
                                  children: [
                                    // --- Заголовок Evently ---
                                    const Center(
                                      child: Text(
                                        'Evently',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w800,
                                          fontSize: 75,
                                          // height: 1.5,
                                          color: AppColors.primaryBlue,
                                          letterSpacing: 1.5
                                        ),
                                      ),
                                    ),
                                    // --- Слоган ---
                                    const Center(
                                      child: Text(
                                        'Откройте для себя новые впечатления',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 50),

                                    // --- Email ---
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: 'name@example.com',
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(
                                              0xFFE0E0E0,
                                            ), // очень светлый серый
                                            width: 1.0, // тонкая линия
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 1.0,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16,
                                            ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Введите email';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (_) => _handleLogin(),
                                    ),
                                    const SizedBox(height: 15),

                                    // --- Пароль ---
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        hintText: '••••••••',
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                          ),
                                          onPressed: () {
                                            setState(
                                              () => _obscurePassword =
                                                  !_obscurePassword,
                                            );
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(
                                              0xFFE0E0E0,
                                            ), // очень светлый серый
                                            width: 1.0, // тонкая линия
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 1.0,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16,
                                            ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Введите пароль';
                                        }
                                        if (value.length < 6) {
                                          return 'Пароль должен быть не менее 6 символов';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (_) => _handleLogin(),
                                    ),
                                    const SizedBox(height: 10),

                                    // --- Забыли пароль? ---
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // TODO: Переход на восстановление пароля
                                        },
                                        child: const Text(
                                          'Забыли пароль?',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // --- Распорка, прижимающая низ к краю экрана ---
                                    // const Spacer(),
                                    SizedBox(
                                      height: 55,
                                      child: ElevatedButton(
                                        onPressed: _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryBlackSea,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'Вход',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),

                                    // --- Кнопка Sign Up ---
                                    SizedBox(
                                      height: 55,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(context, '/registration');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'Регистрация',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<LoginModel>(context, listen: false);
      await auth.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      print(auth.toString());

      // Проверяем, что токен получен и сохранен
      if (auth.token != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Обработка ошибки, если токен не получен
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка входа: не удалось получить токен'),
          ),
        );
      }
    }
  }
}
