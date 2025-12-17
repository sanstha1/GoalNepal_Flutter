import 'package:flutter/material.dart';
import 'package:goal_nepal/mycolors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.lightYellow,
      child: SizedBox.expand(
        child: Center(
          child: Text('Welcome to Home Screen'),
        ),
      ),
    );
  }
}
