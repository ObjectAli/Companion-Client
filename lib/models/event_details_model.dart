import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../config/auth_storage.dart';
import 'event_model.dart';

class EventDetailsModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EventModel? _event;
  EventModel? get event => _event;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEventCard(String id) async {
    _isLoading = true;
    _event = null;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Получаем токен
      final token = await AuthStorage.getToken();

      // 2. Делаем POST запрос для получения информации о мероприятии по id
      final response = await http.post(
        Uri.parse('${AppConfig.eventsUrl}/card/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // ВАЖНО: Бэк может возвращать данные в обертке (например, { "data": {...} })
        // Если данные лежат сразу в корне, то используйте: jsonData['id']
        // Здесь я предполагаю, что данные в поле 'data'. Проверьте ваш API!
        final data = jsonData['data'] ?? jsonData;

        _event = _parseEvent(data);
      } else if (response.statusCode == 401) {
        _errorMessage = 'Сессия истекла. Войдите снова.';
      } else {
        _errorMessage = 'Ошибка сервера: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Ошибка сети. Проверьте подключение.';
      debugPrint('Fetch event error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Парсим JSON с бэкенда в нашу модель
  EventModel _parseEvent(Map<String, dynamic> data) {
    double _parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return EventModel(
      id: data['id'] ?? '',
      title: data['title'] ?? 'Без названия',
      category: data['category'] ?? 'Другое',
      location: data['locationName'] ?? 'Место не указано',
      date: DateTime.tryParse(data['eventTime'] ?? '') ?? DateTime.now(),
      price: _parseDouble(data['price']),
      imageUrl: 'assets/images/front-image.jpg',
      organizer: data['organizer'] ?? 'Организатор не указан',
      attendeesCount: data['currentParticipants'] ?? 0,
      maxParticipants: data['maxParticipants'] ?? 0,
      description: data['description'],
      isAdults: data['isAdults'] ?? false,
      genderRestriction: data['genderRestriction'] ?? 'any',
    );
  }
}
