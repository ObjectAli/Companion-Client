import 'package:evently_client/config/app_config.dart';
import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../models/event_model.dart';
import '../widgets/bottom_menu.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _searchController = TextEditingController();
  int _selectedFilter = 0;
  int _navIndex = 0;

  final List<String> _filters = [
    'Тренды',
    'Концерты',
    'Походы',
    'Мастер-класс',
    'Спорт',
    'Лекции',
  ];

  // Пример данных (позже замените на запрос к бэку)
  final List<EventModel> _events = [
    EventModel(
      id: '1',
      title: 'Summer Solstice Festival',
      category: 'Музыка',
      location: 'Hyde Park, London',
      date: DateTime(2025, 6, 21, 12, 00),
      price: 85,
      imageUrl: 'https://picsum.photos/seed/summer/800/600',
      isFeatured: true,
      attendeesCount: 1200,
    ),
    EventModel(
      id: '2',
      title: 'Городской забег 10 км',
      category: 'Спорт',
      location: 'Парк Горького, Москва',
      date: DateTime(2025, 7, 12),
      price: 0,
      imageUrl: 'https://picsum.photos/seed/run/800/600',
      attendeesCount: 340,
    ),
    EventModel(
      id: '3',
      title: 'Поход в горы: Эльбрус',
      category: 'Outdoor',
      location: 'Приэльбрусье, КБР',
      date: DateTime(2025, 8, 3),
      price: 4500,
      imageUrl: 'https://picsum.photos/seed/hike/800/600',
      attendeesCount: 45,
    ),
    EventModel(
      id: '4',
      title: 'Киберспортивный турнир CS2',
      category: 'Sport',
      location: 'Онлайн',
      date: DateTime(2025, 7, 25),
      price: 1500,
      imageUrl: 'https://picsum.photos/seed/csgo/800/600',
      isOnline: true,
      attendeesCount: 890,
    ),
    EventModel(
      id: '5',
      title: 'Ночь джаза в баре',
      category: 'Nightlife',
      location: 'Bar 12, Москва',
      date: DateTime(2025, 6, 30),
      price: 800,
      imageUrl: 'https://picsum.photos/seed/jazz/800/600',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featured = _events.firstWhere((e) => e.isFeatured);
    final upcoming = _events.where((e) => !e.isFeatured).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Основной контент
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader()),
                    SliverToBoxAdapter(child: _buildSearch()),
                    SliverToBoxAdapter(child: _buildFilters()),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildFeaturedCard(featured),
                      ),
                    ),
                    SliverToBoxAdapter(child: _buildUpcomingHeader()),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildEventCard(upcoming[index]),
                          ),
                        ),
                        childCount: upcoming.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                ),
              ),
            ),
          ),

          // 2. Парящее меню поверх контента (ИСПРАВЛЕНО)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppConfig.maxWidth),
                child: BottomNavBar(
                  currentIndex: _navIndex,
                  onTap: (index) {
                    if (index == _navIndex) {
                      return; // Уже на этой вкладке — ничего не делаем
                    }
                    setState(() => _navIndex = index);
                    Navigator.pushNamed(
                      context,
                      BottomNavBar.items[index]['route'] as String,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HEADER ====================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Логотип
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    letterSpacing: 1,
                  ),
                  children: [
                    TextSpan(
                      text: 'ПУЛЬС',
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ],
                ),
              ),
              const Text(
                'В ритме событий',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                  color: AppColors.primaryBlackSea,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Кнопка города
          Row(children: [_buildCityButton()]),
        ],
      ),
    );
  }

  Widget _buildCityButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.location_on_outlined, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Москва',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SEARCH ====================
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Найти событие...',
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.blue, width: 1.0),
          ),
        ),
      ),
    );
  }

  // ==================== FILTERS ====================
  Widget _buildFilters() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? AppColors.primaryBlue : AppColors.grey,
                ),
              ),
              child: Row(
                children: [
                  if (index == 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.local_fire_department,
                        size: 20,
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryBlue,
                      ),
                    ),
                  Text(
                    _filters[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : AppColors.primaryBlackSea,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== FEATURED CARD ====================
  Widget _buildFeaturedCard(EventModel event) {
    return GestureDetector(
      onTap: () {
        // TODO: переход на экран деталей
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(event.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.25),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Бейдж РЕКОМЕНДАЦИЯ
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.burgundi,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'РЕКОМЕНДАЦИЯ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            // Дата
            Positioned(top: 16, right: 16, child: _buildDateBadge(event)),

            // Название и локация
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        event.formattedPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== UPCOMING ====================
  Widget _buildUpcomingHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Ближайшие рядом',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlackSea,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Row(
              children: [
                Text(
                  'Все',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventModel event) {
    return GestureDetector(
      onTap: () {
        // TODO: переход на экран деталей
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение + дата
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    event.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 160,
                        color: const Color(0xFFF0F0F0),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) => Container(
                      height: 160,
                      color: const Color(0xFFF0F0F0),
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
                // Дата
                Positioned(top: 12, right: 12, child: _buildDateBadge(event)),
                // Цена
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.formattedPrice,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Онлайн-бейдж
                if (event.isOnline)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Онлайн',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Информация
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlackSea,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.category,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBadge(EventModel event) {
    return Container(
      width: 60, // Компактная ширина
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryBlackSea,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- ВЕРХНЯЯ ЧАСТЬ: Дата ---
          Text(
            event.formattedDate.split(' ')[0], // День (например "21")
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            event.formattedDate.split(' ')[1], // Месяц (например "JUN")
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          // --- ЦЕНТР: Горизонтальная белая линия ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              height: 1.5,
              width: 30, // Ширина линии (можно сделать double.infinity для линии во всю ширину)
              color: Colors.white,
            ),
          ),

          //--- НИЖНЯЯ ЧАСТЬ: Время ---
          Text(
            event.formattedTime, // Например "19:30"
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
