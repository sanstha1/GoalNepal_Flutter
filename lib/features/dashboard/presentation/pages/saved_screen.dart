import 'package:flutter/material.dart';
import 'package:goal_nepal/app/theme/mycolors.dart';
import 'package:goal_nepal/features/dashboard/presentation/widgets/saved_tournament.dart';

class SavedTournamentData {
  final String title;
  final String location;
  final String date;
  final String image;

  SavedTournamentData({
    required this.title,
    required this.location,
    required this.date,
    required this.image,
  });
}

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final List<SavedTournamentData> savedTournaments = [
    SavedTournamentData(
      title: "Kathmandu Futsal Cup 2025",
      location: "Kathmandu, Nepal",
      date: "Jan 1 - Jan 14, 2026",
      image: "assets/images/futsal.jpg",
    ),
    SavedTournamentData(
      title: "Pokhara Football League 2026",
      location: "Pokhara, Nepal",
      date: "Feb 5 - Feb 20, 2026",
      image: "assets/images/football.jpg",
    ),
    SavedTournamentData(
      title: "Lalitpur City Cup Association",
      location: "Lalitpur, Nepal",
      date: "Nov 20 - Dec 10, 2025",
      image: "assets/images/football2.jpg",
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
                  children: [
                    const Text(
                      "Saved Tournaments",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "You have ${savedTournaments.length} saved tournaments",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SavedSearchFilterHeader(),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
              sliver: savedTournaments.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "No saved tournaments yet",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final t = savedTournaments[index];
                        return SavedTournament(
                          imageUrl: t.image,
                          title: t.title,
                          location: t.location,
                          date: t.date,
                          onRegister: () {
                            // TODO: navigate to register
                          },
                          onRemove: () {
                            setState(() {
                              savedTournaments.removeAt(index);
                            });
                          },
                        );
                      }, childCount: savedTournaments.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedSearchFilterHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: MyColors.lightYellow,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search tournaments...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
