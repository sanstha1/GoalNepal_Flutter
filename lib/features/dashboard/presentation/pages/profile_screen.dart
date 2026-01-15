import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBEA),
        elevation: 0,
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit, size: 18),
            label: const Text("Edit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B7C93),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _infoCard(),
                  const SizedBox(height: 16),
                  _statsCard(),
                  const SizedBox(height: 16),
                  _teamCard(),
                  const SizedBox(height: 16),
                  _settingsCard(context),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _infoCard(),
                      const SizedBox(height: 16),
                      _statsCard(),
                      const SizedBox(height: 16),
                      _teamCard(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: _settingsCard(context)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _infoCard() {
    return _card(
      title: "Personal Information",
      icon: Icons.person,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _infoRow("Full Name", "Santosh Shrestha", Icons.badge),
          SizedBox(height: 10),
          _infoRow("Email", "sthasantosh070@gmail.com", Icons.email),
          SizedBox(height: 10),
          _infoRow("Phone", "+977-9848843744", Icons.phone),
        ],
      ),
    );
  }

  Widget _statsCard() {
    return _card(
      title: "Player Statistics",
      icon: Icons.emoji_events,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statBox("12", "Goals"),
          _statBox("5", "Assists"),
          _statBox("8", "Matches"),
          _statBox("4.5", "Rating"),
        ],
      ),
    );
  }

  Widget _teamCard() {
    return _card(
      title: "Team Information",
      icon: Icons.groups,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Team Name",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text("Mountain Kings", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text("Role: Player"), Text("Joined: Jan 2024")],
          ),
          const SizedBox(height: 16),
          const Text(
            "Recent Matches",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _matchTile(
            "vs Valley United",
            "Feb 14, 2025",
            "2-1 Win",
            Colors.green,
          ),
          _matchTile("vs City Stars", "Feb 10, 2025", "1-1 Draw", Colors.blue),
          _matchTile(
            "vs Central Region",
            "Feb 5, 2025",
            "3-0 Win",
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(BuildContext context) {
    return _card(
      title: "Settings",
      icon: Icons.settings,
      child: Column(
        children: [
          _settingTile(
            Icons.lock,
            "Change Password",
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),
          _settingTile(
            Icons.notifications,
            "Notifications",
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          const Divider(),
          _settingTile(
            Icons.dark_mode,
            "Dark Mode",
            trailing: Switch(value: false, onChanged: (v) {}),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => _showLogoutDialog(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: Color(0xFF6B7C93)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(color: Color(0xFF6B7C93)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF6B7C93)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  static Widget _statBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  static Widget _matchTile(
    String opponent,
    String date,
    String result,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opponent,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(date, style: const TextStyle(fontSize: 12)),
            ],
          ),
          Text(
            result,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static Widget _settingTile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _infoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _infoRow(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
