import 'package:evently_client/screens/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/login_model.dart';
import 'models/registration_model.dart';

import 'screens/sign_in.dart';
import 'screens/profile.dart';
import 'screens/registration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Ваша текущая модель для входа
        ChangeNotifierProvider(create: (context) => LoginModel()),

        // Новая модель для регистрации
        ChangeNotifierProvider(create: (context) => RegistrationModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Отключает баннер DEBUG
        title: 'Evently',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: '/feed',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/registration': (context) => const RegistrationScreen(),
          '/feed': (context) => const FeedScreen()
        },
      ),
    );
  }
}
