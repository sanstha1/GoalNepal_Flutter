import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goal_nepal/core/utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  // Selected profile image
  XFile? _selectedImage;

  /// LOGOUT FUNCTION
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  /// LOGOUT CONFIRMATION DIALOG
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

  /// REQUEST PERMISSION - Reusable permission handler
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  /// PERMISSION DENIED DIALOG - Shows when permission is permanently denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "This feature requires permission to access your camera or gallery. Please enable it in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// PICK IMAGE FROM CAMERA - Captures photo using device camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedImage = photo;
      });

      // TODO: Upload photo to server
      // await ref.read(profileViewModelProvider.notifier).uploadPhoto(File(photo.path));
    }
  }

  /// PICK IMAGE FROM GALLERY - Selects existing photo from device
  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });

        // TODO: Upload photo to server
        // await ref.read(profileViewModelProvider.notifier).uploadPhoto(File(image.path));
      }
    } catch (e) {
      debugPrint('Gallery Error: $e');

      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  /// SHOW IMAGE PICKER BOTTOM SHEET - Modal to choose camera or gallery
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.browse_gallery),
                title: const Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
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

  /// PERSONAL INFO CARD - Contains profile picture and user details
  Widget _infoCard() {
    return _card(
      title: "Personal Information",
      icon: Icons.person,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF6B7C93),
                  backgroundImage: _selectedImage != null
                      ? FileImage(File(_selectedImage!.path))
                      : null,
                  child: _selectedImage == null
                      ? const Text(
                          "SS",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                // Edit icon overlay
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B7C93),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _InfoRow("Full Name", "Santosh Shrestha", Icons.badge),
          const SizedBox(height: 10),
          const _InfoRow("Email", "sthasantosh070@gmail.com", Icons.email),
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
        children: const [
          _StatBox("12", "Goals"),
          _StatBox("5", "Assists"),
          _StatBox("8", "Matches"),
          _StatBox("4.5", "Rating"),
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
        children: const [
          Text("Team Name", style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text("Mountain Kings", style: TextStyle(fontSize: 16)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Role: Player"), Text("Joined: Jan 2024")],
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
          _settingTile(Icons.lock, "Change Password"),
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
            ),
            child: const Text("Logout"),
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: trailing,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoRow(this.title, this.value, this.icon);

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

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox(this.value, this.label);

  @override
  Widget build(BuildContext context) {
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
}
