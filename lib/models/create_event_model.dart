class CreateEventModel {
  final String title;
  final String? description;
  final String? category;
  final String eventTime; // Отправляем в ISO 8601
  final String? eventEndTime;
  final bool isAdults;
  final String genderRestriction;
  final String? locationName;
  final double locationLat;
  final double locationLon;
  final int price;
  final int maxParticipants;

  CreateEventModel({
    required this.title,
    this.description,
    this.category,
    required this.eventTime,
    this.eventEndTime,
    required this.isAdults,
    required this.genderRestriction,
    this.locationName,
    required this.locationLat,
    required this.locationLon,
    required this.price,
    required this.maxParticipants,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'eventTime': eventTime,
      'eventEndTime': eventEndTime,
      'isAdults': isAdults,
      'genderRestriction': genderRestriction,
      'locationName': locationName,
      'locationLat': locationLat,
      'locationLon': locationLon,
      'price': price,
      'maxParticipants': maxParticipants,
    };
  }
}