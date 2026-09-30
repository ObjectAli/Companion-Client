import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    // Имитация API-запроса
    await Future.delayed(const Duration(seconds: 2));
    
    // Здесь ваша логика авторизации
    
    _isLoading = false;
    notifyListeners();
  }
}