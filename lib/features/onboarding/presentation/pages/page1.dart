import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png'),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your',
                      style: TextStyle(
                        fontSize: 45,
                        color: Colors.black,
                        letterSpacing: 10,
                      ),
                    ),
                    TextSpan(
                      text: 'Game,',
                      style: TextStyle(
                        fontSize: 80,
                        letterSpacing: 10,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Your',
                      style: TextStyle(
                        fontSize: 45,
                        color: Colors.black,
                        letterSpacing: 10,
                      ),
                    ),
                    TextSpan(
                      text: 'Stage!',
                      style: TextStyle(
                        fontSize: 80,
                        letterSpacing: 10,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
