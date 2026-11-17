import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import '../config/auth_storage.dart'; // <--- Импортируем AuthStorage

class LoginModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _token = null; // Сбрасываем токен перед попыткой входа
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(AppConfig.authUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];

        // --- СОХРАНЯЕМ ТОКЕН В БЕЗОПАСНОЕ ХРАНИЛИЩЕ ---
        if (_token != null) {
          await AuthStorage.saveToken(_token!);
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _token = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Выход из аккаунта: очищаем токен из памяти и из хранилища
Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await AuthStorage.getToken();
      
      if (token != null) {
        // Отправляем POST-запрос на /logout
        await http.post(
          Uri.parse(AppConfig.logoutUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Передаем токен, чтобы сервер знал, кого разлогинить
          },
        );
      }
    } catch (e) {
      // Если сеть упала, мы все равно должны разлогинить пользователя локально
      debugPrint('Logout API error: $e');
    } finally {
      // В ЛЮБОМ СЛУЧАЕ очищаем токен на клиенте
      _token = null;
      await AuthStorage.clearToken();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Проверка, авторизован ли пользователь (при старте приложения)
  /// Возвращает true, если токен есть в хранилище, и загружает его в модель
  Future<bool> checkAuth() async {
    final savedToken = await AuthStorage.getToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      notifyListeners();
      return true;
    }
    return false;
  }
}