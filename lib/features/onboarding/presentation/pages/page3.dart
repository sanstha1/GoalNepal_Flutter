import 'package:flutter/material.dart';
import 'package:goal_nepal/app/theme/mycolors.dart';
import 'package:goal_nepal/features/dashboard/presentation/widgets/my_button.dart';

import '../../../auth/presentation/pages/login_screen.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key, required Null Function() onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.darkGray,
      child: Column(
        children: [
          const Spacer(flex: 1),

          ClipOval(
            child: Image.asset(
              'assets/images/tournament.jpg',
              width: 260,
              height: 260,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            "Manage Tournaments Easily",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Create tournaments, manage teams, and track live scores all in one place.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MyButton(
              text: 'Get Started',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
