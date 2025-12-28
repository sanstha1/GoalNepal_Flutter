import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDEB),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Tournament News & Updates",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Stay updated with the latest news, live matches, and player highlights",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          const Text(
            "Latest News",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _newsCard(
            badge: "NEWS",
            badgeColor: Colors.blue.shade100,
            badgeTextColor: Colors.blue.shade800,
            title: "Nepal Football Championship 2025 Begins",
            description:
                "The much-awaited Nepal Football Championship kicked off today with an exciting opening match between Kathmandu FC and Valley United.",
            time: "Today, 2:30 PM",
            bgColor: const Color(0xFFF1F7FF),
          ),
          const SizedBox(height: 16),
          _newsCard(
            badge: "LIVE",
            badgeColor: Colors.red.shade100,
            badgeTextColor: Colors.red.shade800,
            title: "LIVE: Championship Final - Mountain Kings vs City Stars",
            description:
                "The championship final is happening right now! Mountain Kings currently leading 2-1 with 15 minutes remaining.",
            time: "Live Now",
            bgColor: const Color(0xFFFFF1F1),
          ),
          const SizedBox(height: 16),
          _newsCard(
            badge: "RESULT",
            badgeColor: Colors.green.shade100,
            badgeTextColor: Colors.green.shade800,
            title: "Yesterday's Results",
            description:
                "Kathmandu FC 3 - 1 Valley United | Pokhara United 2 - 2 Central Region",
            time: "Yesterday",
            bgColor: const Color(0xFFF1FFF5),
          ),
          const SizedBox(height: 16),
          _newsCard(
            badge: "MAN OF THE MATCH",
            badgeColor: Colors.orange.shade100,
            badgeTextColor: Colors.orange.shade800,
            title: "Man of the Match - Ronish Lama",
            description:
                "Outstanding performance with 3 goals and 2 assists in the championship opener.",
            time: "Today",
            bgColor: const Color(0xFFFFFAE6),
          ),
          const SizedBox(height: 30),
          const Text(
            "Upcoming Matches",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _matchCard(
            date: "Feb 15, 3:00 PM",
            team1: "Kathmandu FC",
            team2: "Valley United",
          ),
          _matchCard(
            date: "Feb 16, 4:00 PM",
            team1: "Pokhara United",
            team2: "Mountain Kings",
          ),
          _matchCard(
            date: "Feb 17, 3:30 PM",
            team1: "Central Region",
            team2: "City Stars",
          ),
        ],
      ),
    );
  }

  Widget _newsCard({
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    required String title,
    required String description,
    required String time,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _matchCard({
    required String date,
    required String team1,
    required String team2,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 6),
              Text(date),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Text(team1, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                const Text("vs", style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 4),
                Text(team2, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F849B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text("Set Reminder"),
            ),
          ),
        ],
      ),
    );
  }
}
