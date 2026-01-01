import 'package:flutter/material.dart';
import 'package:goal_nepal/app/theme/mycolors.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/home_screen.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/news_screen.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/saved_screen.dart';

class ButtomNavigationScreen extends StatefulWidget {
  const ButtomNavigationScreen({super.key});

  @override
  State<ButtomNavigationScreen> createState() => _ButtomNavigationScreenState();
}

class _ButtomNavigationScreenState extends State<ButtomNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> bottomScreens = const [
    HomeScreen(),
    NewsScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          title: Image.asset(
            'assets/images/second.png',
            height: 80,
            fit: BoxFit.contain,
          ),
          backgroundColor: MyColors.blueGray,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 15),
              child: IconButton(
                icon: const Icon(
                  Icons.circle_notifications,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      body: bottomScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.blueGray,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outlined),
            label: 'Saved',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
