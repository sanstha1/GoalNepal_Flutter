import 'package:flutter/material.dart';
import 'package:goal_nepal/app/theme/mycolors.dart';
import 'package:goal_nepal/features/dashboard/presentation/widgets/filter.dart';
import '../widgets/tournament_card.dart';

class Tournament {
  final String title;
  final String location;
  final String date;
  final String image;

  Tournament({
    required this.title,
    required this.location,
    required this.date,
    required this.image,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Tournament> tournaments = [
    Tournament(
      title: "Kathmandu Futsal Cup 2025",
      location: "Kathmandu, Nepal",
      date: "Jan 1 - Jan 14, 2026",
      image: "assets/images/futsal.jpg",
    ),
    Tournament(
      title: "Pokhara Football League 2026",
      location: "Pokhara, Nepal",
      date: "Feb 5 - Feb 20, 2026",
      image: "assets/images/football.jpg",
    ),
    Tournament(
      title: "Lalitpur City Cup Association",
      location: "Lalitpur, Nepal",
      date: "Nov 20 - Dec 10, 2025",
      image: "assets/images/football2.jpg",
    ),
    Tournament(
      title: "Chitwan Futsal Championship",
      location: "Chitwan, Nepal",
      date: "Apr 1 - Apr 15, 2026",
      image: "assets/images/futsal2.jpg",
    ),
    Tournament(
      title: "Butwal Open Tournament Pro",
      location: "Butwal, Nepal",
      date: "May 3 - May 18, 2026",
      image: "assets/images/football3.jpg",
    ),
    Tournament(
      title: "Biratnagar Premier Futsal Cup",
      location: "Biratnagar, Nepal",
      date: "Jun 7 - Jun 22, 2026",
      image: "assets/images/futsal3.jpg",
    ),
  ];

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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final t = tournaments[index];
                  return TournamentCard(
                    title: t.title,
                    location: t.location,
                    date: t.date,
                    imagePath: t.image,
                    onRegister: () {},
                  );
                }, childCount: tournaments.length),
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
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
          Filter(onTap: () {}),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
