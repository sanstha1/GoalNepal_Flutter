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

  //Indicates which page we are on
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              Page1(),
              Page2(),
              Page3()
            ],
          ),
          Container(
            alignment: Alignment(0,0.8),
              child: SmoothPageIndicator(
                  controller: _controller, count: 3))
        ],
      ),
    );
  }
}
