import 'package:flutter/material.dart';
import 'package:goal_nepal/app/theme/mycolors.dart';
import 'package:goal_nepal/features/onboarding/presentation/pages/page1.dart';
import 'package:goal_nepal/features/onboarding/presentation/pages/page2.dart';
import 'package:goal_nepal/features/onboarding/presentation/pages/page3.dart';
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
      backgroundColor: MyColors.blueGray,
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
            alignment: Alignment(0, 0.92),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.blue,
                    // ignore: deprecated_member_use
                    dotColor: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 20),
                if (currentPage < 2)
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
