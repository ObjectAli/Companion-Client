class EventModel {
  final String id;
  final String title;
  final String category;
  final String location;
  final DateTime date;
  final double price;
  final String imageUrl;
  final String? organizer;
  final bool isFeatured;
  final bool isOnline;
  final int attendeesCount;
  final String? description;
  final int maxParticipants;
  final bool isAdults;
  final String genderRestriction;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.date,
    required this.price,
    required this.imageUrl,
    this.organizer,
    this.isFeatured = false,
    this.isOnline = false,
    this.attendeesCount = 0,
    this.description,
    this.maxParticipants = 0,
    this.isAdults = false,
    this.genderRestriction = 'any',
  });

  
  // --- Дата (например: "21 ИЮН") ---
  String get formattedDate {
    const months = [
      'ЯНВ',
      'ФЕВ',
      'МАР',
      'АПР',
      'МАЙ',
      'ИЮН',
      'ИЮЛ',
      'АВГ',
      'СЕН',
      'ОКТ',
      'НОЯ',
      'ДЕК',
    ];
    // const weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return '${date.day} ${months[date.month - 1]}';
  }

  String get formattedDateAlt {
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // --- День недели (например: "Пн") ---
  String get weekday {
    const weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return weekdays[date.weekday - 1];
  }

  // --- Время (например: "19:30") ---
  String get formattedTime {
    // padLeft(2, '0') добавляет ведущий ноль, если число однозначное (9 -> 09)
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  // --- Полная дата и время (например: "21 JUN, 19:30") ---
  // Удобно для экрана деталей мероприятия
  String get formattedDateTime {
    return '$formattedDate, $formattedTime';
  }

  String get formattedDateTimeForEventlyCard {
    return '${formattedDateAlt.toLowerCase()}, $formattedTime';
  }

  String get formattedPrice {
    if (price == 0) return 'Бесплатно';
    return '${price.toStringAsFixed(0)} ₽';
  }
}