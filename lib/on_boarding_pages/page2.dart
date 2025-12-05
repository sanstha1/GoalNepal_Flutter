import 'package:flutter/material.dart';
import 'package:goal_nepal/mycolors.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightYellow,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),

            ClipOval(
              child: Image.asset(
                'assets/images/football_news.png',
                width: 260,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 160),

            const Text(
              "Stay Updated With Football News",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 22),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Get the latest updates, match fixtures, and live coverage straight from GoalNepal.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
