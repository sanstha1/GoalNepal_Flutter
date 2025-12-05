import 'package:flutter/material.dart';
import 'package:goal_nepal/on_boarding_pages/page1.dart';
import 'package:goal_nepal/on_boarding_pages/page2.dart';
import 'package:goal_nepal/on_boarding_pages/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              Page1(),
              Page2(),
              Page3(
                onGetStarted: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            ],
          ),


          Align(
            alignment: Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                if (currentPage != 0)
                  GestureDetector(
                    onTap: () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Text('Previous', style: TextStyle(fontSize: 16)),
                  )
                else
                  const SizedBox(width: 70),


                SmoothPageIndicator(controller: _controller, count: 3),


                if (currentPage != 2)
                  GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Text('Next', style: TextStyle(fontSize: 16)),
                  )
                else
                  const SizedBox(width: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
