import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/app/theme/mycolors.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/presentation/state/tournament_state.dart';
import 'package:goal_nepal/features/tournament/presentation/view_model/tournament_viewmodel.dart';
import '../widgets/tournament_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TournamentType? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tournamentViewModelProvider.notifier).getAllTournaments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tournamentState = ref.watch(tournamentViewModelProvider);

    final displayedTournaments = _selectedCategory == null
        ? tournamentState.tournaments
        : tournamentState.tournaments
              .where((t) => t.type == _selectedCategory)
              .toList();

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
              delegate: _CategoryFilterHeader(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
            ),
            if (tournamentState.status == TournamentStatus.loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (tournamentState.status == TournamentStatus.error)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    tournamentState.errorMessage ?? 'Something went wrong',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (displayedTournaments.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('No tournaments found')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 20,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final t = displayedTournaments[index];
                    return TournamentCard(
                      tournament: t,
                      title: t.title,
                      location: t.location,
                      date:
                          '${t.startDate.day} ${_monthName(t.startDate.month)} - ${t.endDate.day} ${_monthName(t.endDate.month)}, ${t.endDate.year}',
                      imagePath: t.bannerImage ?? '',
                    );
                  }, childCount: displayedTournaments.length),
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

class _CategoryFilterHeader extends SliverPersistentHeaderDelegate {
  final TournamentType? selectedCategory;
  final Function(TournamentType?) onCategorySelected;

  _CategoryFilterHeader({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

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
            child: _CategoryButton(
              label: 'All',
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _CategoryButton(
              label: 'Football',
              isSelected: selectedCategory == TournamentType.football,
              onTap: () => onCategorySelected(TournamentType.football),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _CategoryButton(
              label: 'Futsal',
              isSelected: selectedCategory == TournamentType.futsal,
              onTap: () => onCategorySelected(TournamentType.futsal),
            ),
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
  bool shouldRebuild(covariant _CategoryFilterHeader oldDelegate) =>
      selectedCategory != oldDelegate.selectedCategory;
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
