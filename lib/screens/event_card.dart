import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_colors.dart';
import '../config/app_config.dart';
import '../models/event_model.dart';
import '../models/event_details_model.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel? event; // Событие опционально
  final String? eventId; // Можно передать ID для загрузки

  const EventDetailsScreen({super.key, this.event, this.eventId})
    : assert(event != null || eventId != null, 'Передайте объект или его id');

  @override
  Widget build(BuildContext context) {
    // Если event уже передан (из ленты) - показываем его.
    if (event != null) {
      return _buildScreen(context, event!);
    }
    // Если передан только ID - загружаем с бэка
    return ChangeNotifierProvider(
      create: (_) => EventDetailsModel()..fetchEventCard(eventId!),
      child: Consumer<EventDetailsModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (model.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Ошибка')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        model.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Назад'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (model.event == null) {
            return const Scaffold(
              body: Center(child: Text('Мероприятие не найдено')),
            );
          }
          return _buildScreen(context, model.event!);
        },
      ),
    );
  }

  Widget _buildScreen(BuildContext context, EventModel event) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- 1. ОСНОВНОЙ КОНТЕНТ (С ОГРАНИЧЕНИЕМ ШИРИНЫ) ---
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth),
              child: CustomScrollView(
                slivers: [
                  // --- ШАПКА С КАРТИНКОЙ ---
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryBlackSea,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            child: Image.asset(
                              event.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- ОСНОВНОЙ КОНТЕНТ (ОПИСАНИЕ) ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Описание',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            event.description ?? 'Описание пока не добавлено.',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 12),

                          // Дата и время
                          _buildInfoRow(
                            Icons.calendar_today_sharp,
                            'Дата и время',
                            event.formattedDateTimeForEventlyCard,
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            Icons.location_on_outlined,
                            'Место',
                            event.location,
                          ),
                          const SizedBox(height: 12),

                          // Цена
                          _buildInfoRow(
                            Icons.currency_ruble_outlined,
                            'Стоимость',
                            event.formattedPrice,
                          ),
                          const SizedBox(height: 12),

                          if (event.organizer != null)
                            _buildInfoRow(
                              Icons.person_outline,
                              'Организатор',
                              event.organizer!,
                            ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.people_outline,
                            'Подписалось',
                            '${event.attendeesCount} / ${event.maxParticipants}',
                          ),
                          
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),

                          // --- Категория и 18+ в одном блоке ---
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // Категория (например, "Музыка")
                              if (event.category != 'other')
                                _buildTag(
                                  event.category,
                                  AppColors.primaryBlue,
                                ),

                              // 18+
                              if (event.isAdults)
                                _buildTag('18+', AppColors.burgundi),

                              // Пол
                              if (event.genderRestriction == 'male')
                                _buildTag(
                                  'Только мужской пол',
                                  AppColors.primaryBlackSea,
                                ),
                              if (event.genderRestriction == 'female')
                                _buildTag(
                                  'Только женский пол',
                                  AppColors.primaryPurple,
                                ),
                            ],
                          ),

                          const SizedBox(
                            height: 100,
                          ), // Отступ, чтобы кнопка не перекрывала контент
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 2. ПАРЯЩАЯ КНОПКА СНИЗУ ---
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth - 80),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Логика записи
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 55),
                        ),
                        child: Text(
                          event.price == 0
                              ? 'Записаться бесплатно'
                              : 'Оплатить участие',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlackSea,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        // Просто иконка без фона
        Icon(icon, color: AppColors.primaryBlackSea, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlackSea,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
