import 'package:flutter/material.dart';
import 'package:goal_nepal/mycolors.dart';
import 'package:goal_nepal/widgets/filter.dart';
import '../../widgets/tournament_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightYellow,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 23),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Ongoing Tournaments",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Discover and register for the best football and futsal tournaments in Nepal",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchFilterHeader(),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => TournamentCard(
                    title: "Kathmandu Futsal Cup 2025",
                    location: "Kathmandu, Nepal",
                    date: "Jan 1 - Jan 14, 2026",
                    imagePath: 'assets/images/logo.png', onRegister: () {  },
                  ),
                  childCount: 6,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchFilterHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: MyColors.lightYellow,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search tournaments...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Filter(
            onTap: () {
              // filter opens
            },
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
