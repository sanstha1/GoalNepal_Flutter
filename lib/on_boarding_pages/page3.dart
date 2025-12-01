import 'package:flutter/material.dart';
import 'package:goal_nepal/widgets/my_button.dart';

class Page3 extends StatelessWidget {
  final VoidCallback onGetStarted;

  const Page3({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2), // top spacing
          const Center(
            child: Text(
              "Page 3",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(), // spacing between text and button

          // Get Started button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MyButton(
              text: 'Get Started',
              onPressed: onGetStarted,
            ),
          ),

          const Spacer(flex: 1), // spacing below button for dot indicator
        ],
      ),
    );
  }
}
