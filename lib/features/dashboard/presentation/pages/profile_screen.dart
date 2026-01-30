import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/api/api_endpoints.dart';
import 'package:goal_nepal/core/utils/my_snackbar.dart';
import 'package:goal_nepal/features/auth/presentation/state/auth_state.dart';
import 'package:goal_nepal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).getCurrentUser();
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
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

  Future<void> _uploadProfilePicture(File imageFile) async {
    setState(() {
      _isUploading = true;
    });

    try {
      await ref
          .read(authViewModelProvider.notifier)
          .uploadProfilePicture(imageFile);

      if (mounted) {
        SnackbarUtils.showSuccess(
          context,
          'Profile picture updated successfully',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Failed to upload profile picture');
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

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

      await _uploadProfilePicture(File(photo.path));
    }
  }

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

        await _uploadProfilePicture(File(image.path));
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
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.status == AuthStatus.loading;

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 700) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _infoCard(authState),
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
                            _infoCard(authState),
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

  Widget _infoCard(AuthState authState) {
    final user = authState.authEntity;
    final profilePictureUrl =
        user?.profilePicture != null && user!.profilePicture!.isNotEmpty
        ? ApiEndpoints.profilePicture(user.profilePicture!)
        : null;

    return _card(
      title: "Personal Information",
      icon: Icons.person,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _isUploading ? null : _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF6B7C93),
                  backgroundImage: _selectedImage != null
                      ? FileImage(File(_selectedImage!.path))
                      : profilePictureUrl != null
                      ? NetworkImage(profilePictureUrl)
                      : null,
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : _selectedImage == null && profilePictureUrl == null
                      ? Text(
                          user?.fullName.substring(0, 2).toUpperCase() ?? "SS",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                if (!_isUploading)
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
          _InfoRow("Full Name", user?.fullName ?? "N/A", Icons.badge),
          const SizedBox(height: 10),
          _InfoRow("Email", user?.email ?? "N/A", Icons.email),
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
