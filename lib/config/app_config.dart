class AppConfig {
  static const String baseUrl = 'http://localhost';
  static const int port = 8080;

  static String get authUrl => '$baseUrl:$port/auth/login';
  static String get logoutUrl => '$baseUrl:$port/auth/logout';
  static String get registrationUrl => '$baseUrl:$port/registration';
  static String get eventsUrl => '$baseUrl:$port/events';

  static const double maxWidth = 500;

  static const String imageUrl = 'assets/images/front-image.jpg';
}