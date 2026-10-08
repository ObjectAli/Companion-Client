import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/auth_model.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Отключает баннер DEBUG
        title: 'Evently',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}