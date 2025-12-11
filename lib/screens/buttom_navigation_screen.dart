import 'package:flutter/material.dart';
import 'package:goal_nepal/mycolors.dart';
import 'package:goal_nepal/screens/buttom_screens/home_screen.dart';
import 'package:goal_nepal/screens/buttom_screens/news_screen.dart';
import 'package:goal_nepal/screens/buttom_screens/profile_screen.dart';
import 'package:goal_nepal/screens/buttom_screens/saved_screen.dart';

class ButtomNavigationScreen extends StatefulWidget {
  const ButtomNavigationScreen({super.key});

  @override
  State<ButtomNavigationScreen> createState() => _ButtomNavigationScreenState();
}

class _ButtomNavigationScreenState extends State<ButtomNavigationScreen> {

  int _selectedIndex = 0;

  //Must use valid variable name + correct type + add a Profile placeholder
  List<Widget> bottomScreens = const [
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
        ),
      ),
      body: bottomScreens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.blueGray,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outlined),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

    );
  }
}
