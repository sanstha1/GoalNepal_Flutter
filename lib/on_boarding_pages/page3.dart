import 'package:flutter/material.dart';
import 'package:goal_nepal/mycolors.dart';
import 'package:goal_nepal/widgets/my_button.dart';

class Page3 extends StatelessWidget {
  final VoidCallback onGetStarted;

  const Page3({super.key, required this.onGetStarted});

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
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MyButton(
              text: 'Get Started',
              onPressed: onGetStarted,
            ),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}