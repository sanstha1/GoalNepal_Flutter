import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/app/theme/mycolors.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/home_screen.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/news_screen.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/saved_screen.dart';
import 'package:goal_nepal/features/tournament/presentation/pages/add_tournament_page.dart'
    hide MyColors;

class ButtomNavigationScreen extends ConsumerStatefulWidget {
  const ButtomNavigationScreen({super.key});

  @override
  ConsumerState<ButtomNavigationScreen> createState() =>
      _ButtomNavigationScreenState();
}

class _ButtomNavigationScreenState
    extends ConsumerState<ButtomNavigationScreen> {
  int _selectedIndex = 0;

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const NewsScreen();
      case 2:
        return const SavedScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

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
      body: _getCurrentScreen(),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyColors.blueGray,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTournamentPage(),
              ),
            );
          },
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: MyColors.blueGray,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', 0),
              _buildNavItem(Icons.newspaper_outlined, 'News', 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.bookmark_outlined, 'Saved', 2),
              _buildNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white60,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
