import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const String _tokenKey = 'auth_token';
  
  // Создаем экземпляр с настройками по умолчанию.
  // На Android по умолчанию используется шифрование на базе Keystore.
  static const _storage = FlutterSecureStorage();

  /// Сохранить токен после успешного входа
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Получить токен (например, при запуске приложения или запросах к API)
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Удалить токен (при выходе из аккаунта)
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Проверить, авторизован ли пользователь
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}