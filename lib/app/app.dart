import 'package:flutter/material.dart';
import 'package:goal_nepal/features/auth/presentation/pages/login_screen.dart';
import 'package:goal_nepal/features/splash/presentation/pages/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
