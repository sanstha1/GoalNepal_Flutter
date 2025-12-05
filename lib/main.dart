import 'package:flutter/material.dart';
import 'package:goal_nepal/screens/onboarding_screen.dart';
// import 'package:goal_nepal/screens/onboarding_screen.dart';
// import 'package:goal_nepal/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home:OnboardingScreen()
    );
  }
}