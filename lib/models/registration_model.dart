import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../config/app_config.dart';

class RegistrationModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSucceeded = true;
  bool get isSucceeded => _isSucceeded;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> registration(
    String email,
    String username,
    String password,
  ) async {
    _isLoading = true;
    _isSucceeded = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(AppConfig.registrationUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      // 2. Успешная регистрация — это 201 Created, а не 200
      if (response.statusCode == 201 || response.statusCode == 200) {
        _isSucceeded = true;
        _errorMessage = null;
      } else {
        // 3. Пытаемся вытащить сообщение об ошибке от бэка
        _errorMessage = _parseError(response);
        _isSucceeded = false;
      }
    } catch (e) {
      // 4. Сетевые ошибки тоже показываем пользователю
      _errorMessage = 'Не удалось связаться с сервером. Проверьте интернет.';
      _isSucceeded = false;
      debugPrint('Registration error: $e');
    } finally {
      // 5. В finally только снимаем лоадер — НЕ трогаем _isSucceeded
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Пытается вытащить человекочитаемое сообщение из ответа бэка
  String _parseError(http.Response response) {
    try {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data is Map) {
          final msg = data['message'] ?? data['error'] ?? data['detail'];
          if (msg != null && msg.toString().isNotEmpty) {
            return msg.toString();
          }
        }
      }
    } catch (_) {
      // Игнорируем — вернём fallback ниже
    }

    switch (response.statusCode) {
      case 400:
        return 'Некорректные данные';
      case 409:
        return 'Пользователь с таким email или именем уже существует';
      case 422:
        return 'Данные не прошли валидацию';
      case 500:
        return 'Ошибка на сервере. Попробуйте позже';
      default:
        return 'Ошибка регистрации (код ${response.statusCode})';
    }
  }
}
