import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/login_model.dart';
import 'models/registration_model.dart';
import 'screens/sign_in.dart';
import 'screens/navigator.dart';
import 'screens/registration.dart';
// import 'screens/event_card.dart';
import 'screens/test_event_details.dart';


void main() async {
// Обязательно для использования SharedPreferences/SecureStorage до runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Создаем модель и проверяем, есть ли сохраненный токен
  final loginModel = LoginModel();
  final isLoggedIn = await loginModel.checkAuth();

  runApp(MyApp(isLoggedIn: isLoggedIn, loginModel: loginModel));
  }

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final LoginModel loginModel;

  const MyApp({
    super.key, 
    required this.isLoggedIn, 
    required this.loginModel,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Передаем уже созданную модель, чтобы не потерять состояние авторизации
        ChangeNotifierProvider.value(value: loginModel), 
        ChangeNotifierProvider(create: (context) => RegistrationModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Evently',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        
        // Если токен есть — сразу на главный экран, иначе на логин
        initialRoute: isLoggedIn ? '/home' : '/login',
        
        routes: {
          '/login': (context) => const LoginScreen(),
          '/registration': (context) => const RegistrationScreen(),
          '/home': (context) => const NavigationScreen(),
          '/test': (context) => const TestEventDetailsScreen(),
        },
      ),
    );
  }
}
