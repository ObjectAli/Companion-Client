import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../config/auth_storage.dart';
import '../config/app_config.dart';
import '../config/app_colors.dart';
import '../models/create_event_model.dart';

class CreateEventScreen extends StatefulWidget {
  final VoidCallback? onEventCreated;

  const CreateEventScreen({super.key, this.onEventCreated});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // Контроллеры
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  final _maxParticipantsController = TextEditingController();
  final _locationNameController = TextEditingController();

  // Состояния
  String _selectedCategory = 'football';
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  bool _isAdults = false;
  String _genderRestriction = 'any';
  bool _isLoading = false;
  bool _isStartDateError = false;
  bool _isEndDateError = false;
  String? _errorMessage;

  // Заглушка для координат
  final double _lat = 0.0;
  final double _lon = 0.0;

  final List<String> _categories = [
    'football',
    'movie',
    'coffee',
    'hiking',
    'gaming',
    'other',
  ];
  final Map<String, String> _categoryNames = {
    'football': 'Футбол',
    'movie': 'Кино',
    'coffee': 'Кофе',
    'hiking': 'Поход',
    'gaming': 'Киберспорт',
    'other': 'Другое',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _maxParticipantsController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime({required bool isStart}) async {
    final DateTime firstDate = isStart
        ? DateTime.now()
        : (_startDate ?? DateTime.now());

    DateTime initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );
    if (pickedTime == null) return;

    setState(() {
      if (isStart) {
        _startDate = pickedDate;
        _startTime = pickedTime;
        _isStartDateError = false;
      } else {
        _endDate = pickedDate;
        _endTime = pickedTime;
        _isEndDateError = false;
      }
    });
  }

  String? _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return dt.toIso8601String();
  }

  Future<void> _submit() async {
    // 1. Сбрасываем прошлую ошибку
    setState(() => _errorMessage = null);

    // Валидация дат
    bool hasDateError = false;
    if (_startDate == null || _startTime == null) {
      setState(() => _isStartDateError = true);
      hasDateError = true;
    }
    if (!_formKey.currentState!.validate() || hasDateError) {
      setState(() => _errorMessage = 'Заполните обязательные поля');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Получаем токен из безопасного хранилища
      final token = await AuthStorage.getToken();

      // Формируем тело запроса
      final request = CreateEventModel(
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        category: _selectedCategory,
        eventTime: _formatDateTime(_startDate, _startTime)!,
        eventEndTime: _formatDateTime(_endDate, _endTime),
        isAdults: _isAdults,
        genderRestriction: _genderRestriction,
        locationName: _locationNameController.text.trim().isEmpty
            ? null
            : _locationNameController.text.trim(),
        locationLat: _lat,
        locationLon: _lon,
        price: int.tryParse(_priceController.text) ?? 0,
        maxParticipants: int.tryParse(_maxParticipantsController.text) ?? 1,
      );

      // Отправляем запрос с токеном в заголовке
      final response = await http.post(
        Uri.parse(AppConfig.eventsUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null)
            'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context); // Успех — закрываем окно
        }
      } else {
        setState(
          () => _errorMessage = 'Ошибка сервера: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Ошибка сети. Проверьте подключение.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                children: [
                  // --- Заголовок (Крестик + Текст) ---
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 28),
                        color: AppColors.primaryBlackSea,
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Создать мероприятие',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlackSea,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 28), // Заглушка для центровки
                    ],
                  ),

                  const SizedBox(height: 20),
                  // --- Блок 1: Основное ---
                  _buildSectionTitle('Основная информация'),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Название*',
                    hint: 'Например: Утренний футбол',
                    validator: (v) => v!.isEmpty
                        ? _errorMessage = 'Заполните обязательные поля'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _descController,
                    label: 'Описание',
                    hint: 'Расскажите подробнее...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: _inputDecoration('Категория'),
                    iconEnabledColor: AppColors.borderBlue,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryBlackSea,
                    ),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(_categoryNames[cat] ?? cat),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCategory = val!),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Время и место'),
                  _buildDateTimePicker(
                    label: 'Начало*',
                    date: _startDate,
                    time: _startTime,
                    hasError: _isStartDateError,
                    onTap: () => _selectDateTime(isStart: true),
                  ),
                  const SizedBox(height: 12),
                  _buildDateTimePicker(
                    label: 'Окончание',
                    date: _endDate,
                    time: _endTime,
                    hasError: _isEndDateError,
                    onTap: () => _selectDateTime(isStart: false),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _locationNameController,
                    label: 'Название места',
                    hint: 'Стадион Лужники, 3 поле',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 4),
                    child: Text(
                      'Координаты: 55.7558, 37.6173 (заглушка)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Участники и стоимость'),
                  // СТРОКА 1: Цена (60%) и Макс. человек (40%)
                  // ==========================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6, // 60%
                        child: _buildTextField(
                          controller: _priceController,
                          label: 'Цена (₽)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4, // 40%
                        child: _buildTextField(
                          controller: _maxParticipantsController,
                          label: 'Макс. человек*',
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || v.isEmpty || int.tryParse(v) == 0)
                              ? _errorMessage = 'Заполните обязательные поля'
                              : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ==========================================
                  // СТРОКА 2: Пол (60%) и 18+ (40%)
                  // ==========================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6, // 60%
                        child: DropdownButtonFormField<String>(
                          value: _genderRestriction,
                          decoration: _inputDecoration('Пол участников'),
                          iconEnabledColor: AppColors.borderBlue,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryBlackSea,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'any',
                              child: Text('Любой'),
                            ),
                            DropdownMenuItem(
                              value: 'male',
                              child: Text('Только мужчины'),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('Только женщины'),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _genderRestriction = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4, // 40%
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '18+',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryBlackSea,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Transform.scale(
                              scale: 0.8, // Уменьшаем переключатель, чтобы влез
                              child: Switch(
                                value: _isAdults,
                                onChanged: (val) =>
                                    setState(() => _isAdults = val),
                                activeColor: AppColors.borderBlue,
                                materialTapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // Убираем лишние отступы
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ==========================================
                  // БЛОК ОТОБРАЖЕНИЯ ОШИБКИ
                  // ==========================================
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.burgundi.withValues(
                            alpha: 0.1,
                          ), // Легкая заливка
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Скругление, как у полей ввода
                          border: Border.all(
                            color: AppColors.burgundi.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.burgundi,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              // <--- Чтобы текст переносился, если длинный
                              child: Text(
                                _errorMessage!,
                                textAlign: TextAlign
                                    .center, // <--- Текст тоже по центру
                                style: const TextStyle(
                                  color: AppColors.burgundi,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- Кнопка отправки ---
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlackSea,
                        disabledBackgroundColor: AppColors.primaryBlackSea
                            .withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Опубликовать',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Вспомогательные виджеты ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlackSea,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.borderBlue,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

      // --- НОВОЕ: Скрываем текст ошибки под полем ---
      errorStyle: const TextStyle(height: 0, fontSize: 0),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.borderBlue, width: 1),
      ),
      prefixIconColor: AppColors.borderBlue,
      suffixIconColor: AppColors.borderBlue,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _inputDecoration(label).copyWith(hintText: hint),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    DateTime? date,
    TimeOfDay? time,
    required VoidCallback onTap,
    bool hasError = false,
  }) {
    final text = (date != null && time != null)
        ? '${date.day}.${date.month}.${date.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : 'Выбрать';

    final decoration = _inputDecoration(label).copyWith(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: hasError ? AppColors.burgundi : const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: hasError ? AppColors.burgundi : AppColors.borderBlue,
          width: 1,
        ),
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: InputDecorator(
        decoration: decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: date == null
                    ? const Color(0xFFB0B0B0)
                    : AppColors.primaryBlackSea,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: hasError ? AppColors.burgundi : AppColors.borderBlue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
