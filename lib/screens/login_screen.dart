import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_model.dart';

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
    body: SafeArea(
      child: Center( // ← центрирует Column по горизонтали и вертикали
        child: SingleChildScrollView( // ← чтобы не было overflow на маленьких экранах
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400), // ← вся форма не шире 400
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // ← Column по высоте контента
                crossAxisAlignment: CrossAxisAlignment.stretch, // ← дети тянутся на всю ширину формы
                children: [
                  const Icon(Icons.lock_outline, size: 180, color: Colors.blue),
                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Введите email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Введите пароль';
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 50,
                    child: Consumer<AuthModel>(
                      builder: (context, auth, child) {
                        return ElevatedButton(
                          onPressed: auth.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Войти',
                                  style: TextStyle(fontSize: 16),
                                ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {
                      // Переход на экран регистрации
                    },
                    child: const Text('Нет аккаунта? Зарегистрироваться'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<AuthModel>(context, listen: false);
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
          const SnackBar(content: Text('Ошибка входа: не удалось получить токен')),
        );
      }
    }
  }
}