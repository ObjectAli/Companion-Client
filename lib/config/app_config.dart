class AppConfig {
  static const String baseUrl = 'http://localhost';
  static const int port = 8080;

  static String get authUrl => '$baseUrl:$port/auth/login';
  static String get registrationUrl => '$baseUrl:$port/registration';


  static const double maxWidth = 500;
}