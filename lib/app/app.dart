import 'package:flutter/material.dart';
import 'package:goal_nepal/features/splash/presentation/pages/splash_screen.dart';
// import 'package:goal_nepal/main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Nepal',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
