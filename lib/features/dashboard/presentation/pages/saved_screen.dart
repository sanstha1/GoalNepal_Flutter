import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/app/theme/mycolors.dart';
import 'package:goal_nepal/core/api/api_endpoints.dart';
import 'package:goal_nepal/features/dashboard/presentation/providers/saved_tournaments_provider.dart';
import 'package:goal_nepal/features/dashboard/presentation/widgets/saved_tournament.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedTournaments = ref.watch(savedTournamentsProvider);
    final savedNotifier = ref.read(savedTournamentsProvider.notifier);

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
                        final imagePath = t.bannerImage ?? '';
                        final imageUrl = imagePath.isEmpty
                            ? ''
                            : (imagePath.startsWith('http://') ||
                                  imagePath.startsWith('https://'))
                            ? imagePath
                            : ApiEndpoints.tournamentBanner(imagePath);
                        return SavedTournament(
                          imageUrl: imageUrl,
                          title: t.title,
                          location: t.location,
                          date:
                              '${t.startDate.day} ${_monthName(t.startDate.month)} - ${t.endDate.day} ${_monthName(t.endDate.month)}, ${t.endDate.year}',
                          onRegister: () {},
                          onRemove: () => savedNotifier.remove(t),
                        );
                      }, childCount: savedTournaments.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.82,
                          ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int m) => const [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m];
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
