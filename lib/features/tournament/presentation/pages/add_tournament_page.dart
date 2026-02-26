import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/utils/my_snackbar.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../state/tournament_state.dart';
import '../view_model/tournament_viewmodel.dart';

class MyColors {
  static const Color lightYellow = Color(0xFFECEFF1);
  static const Color lightGray = Color(0xFFCBCBCB);
  static const Color darkGray = Color(0xFF4A4A4A);
  static const Color blueGray = Color(0xFF6D8196);
}

class AddTournamentPage extends ConsumerStatefulWidget {
  const AddTournamentPage({super.key});

  @override
  ConsumerState<AddTournamentPage> createState() => _AddTournamentPageState();
}

class _AddTournamentPageState extends ConsumerState<AddTournamentPage> {
  TournamentType _selectedType = TournamentType.football;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _organizerController = TextEditingController();
  final _prizeController = TextEditingController();
  final _maxTeamsController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  XFile? _bannerImage;
  final ImagePicker _imagePicker = ImagePicker();

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day} ${_monthName(date.month)} ${date.year}';
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

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _organizerController.dispose();
    _prizeController.dispose();
    _maxTeamsController.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (status.isDenied) return (await permission.request()).isGranted;
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
        title: const Text('Permission Required'),
        content: const Text(
          'This feature requires access to your camera or gallery. '
          'Please enable it in your device settings.',
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

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (photo != null) {
      setState(() => _bannerImage = photo);
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _bannerImage = image);
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Unable to access gallery. Try using the camera instead.',
        );
      }
    }
  }

  Future<void> _pickBannerImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.lightYellow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: MyColors.lightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add Banner Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyColors.darkGray,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: MyColors.darkGray,
                ),
                title: const Text(
                  'Open Camera',
                  style: TextStyle(color: MyColors.darkGray),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.browse_gallery_rounded,
                  color: MyColors.darkGray,
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: MyColors.darkGray),
                ),
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

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      SnackbarUtils.showError(context, 'Please select start and end dates');
      return;
    }

    await ref
        .read(tournamentViewModelProvider.notifier)
        .createTournament(
          title: _titleController.text.trim(),
          type: _selectedType,
          location: _locationController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          organizer: _organizerController.text.trim().isEmpty
              ? null
              : _organizerController.text.trim(),
          prize: _prizeController.text.trim().isEmpty
              ? null
              : _prizeController.text.trim(),
          maxTeams: int.tryParse(_maxTeamsController.text),
          bannerImage: _bannerImage != null ? File(_bannerImage!.path) : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final tournamentState = ref.watch(tournamentViewModelProvider);

    ref.listen<TournamentState>(tournamentViewModelProvider, (previous, next) {
      if (next.status == TournamentStatus.created) {
        SnackbarUtils.showSuccess(
          context,
          _selectedType == TournamentType.football
              ? 'Football tournament added successfully!'
              : 'Futsal tournament added successfully!',
        );
        Navigator.pop(context);
      } else if (next.status == TournamentStatus.error &&
          next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: MyColors.lightYellow,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: MyColors.darkGray,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Add Tournament',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: MyColors.darkGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _selectedType = TournamentType.football,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _selectedType == TournamentType.football
                                        ? MyColors.blueGray
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '⚽',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Football',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              _selectedType ==
                                                  TournamentType.football
                                              ? Colors.white
                                              : MyColors.darkGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _selectedType = TournamentType.futsal,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _selectedType == TournamentType.futsal
                                        ? MyColors.blueGray
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '🥅',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Futsal',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              _selectedType ==
                                                  TournamentType.futsal
                                              ? Colors.white
                                              : MyColors.darkGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Banner Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MyColors.darkGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildBannerUploader(),
                      const SizedBox(height: 24),
                      _buildLabel('Tournament Title'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _titleController,
                        hint: 'e.g., Kathmandu Futsal Cup 2025',
                        prefixIcon: Icons.emoji_events_rounded,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter tournament title'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      _buildLabel('Location'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _locationController,
                        hint: 'e.g., Kathmandu, Nepal',
                        prefixIcon: Icons.location_on_rounded,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter location'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      _buildLabel('Date Range'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateTile(
                              label: 'Start Date',
                              icon: Icons.calendar_today_rounded,
                              value: _formatDate(_startDate),
                              onTap: _pickStartDate,
                              isSelected: _startDate != null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDateTile(
                              label: 'End Date',
                              icon: Icons.event_rounded,
                              value: _formatDate(_endDate),
                              onTap: _pickEndDate,
                              isSelected: _endDate != null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildLabel('Organizer'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _organizerController,
                        hint: 'e.g., Nepal Football Association',
                        prefixIcon: Icons.groups_rounded,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Prize Pool'),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _prizeController,
                                  hint: 'e.g., NPR 50,000',
                                  prefixIcon: Icons.military_tech_rounded,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Max Teams'),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _maxTeamsController,
                                  hint: 'e.g., 16',
                                  prefixIcon: Icons.people_alt_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildLabel('Description'),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          style: const TextStyle(color: MyColors.darkGray),
                          decoration: const InputDecoration(
                            hintText:
                                'Describe the tournament rules, format, prizes...',
                            hintStyle: TextStyle(color: MyColors.lightGray),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      GestureDetector(
                        onTap:
                            tournamentState.status == TournamentStatus.loading
                            ? null
                            : _handleSubmit,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: MyColors.blueGray,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child:
                              tournamentState.status == TournamentStatus.loading
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_circle_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Add ${_selectedType == TournamentType.football ? 'Football' : 'Futsal'} Tournament',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MyColors.darkGray,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: MyColors.darkGray),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: MyColors.lightGray),
          prefixIcon: Icon(prefixIcon, color: MyColors.darkGray),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDateTile({
    required String label,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.blueGray : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white70 : MyColors.darkGray,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white70 : MyColors.darkGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : MyColors.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerUploader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickBannerImage,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: MyColors.lightGray,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: MyColors.blueGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add Banner',
                  style: TextStyle(
                    fontSize: 11,
                    color: MyColors.darkGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (_bannerImage != null)
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(_bannerImage!.path),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          // ignore: deprecated_member_use
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      _selectedType == TournamentType.football
                          ? '⚽ Football'
                          : '🥅 Futsal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => setState(() => _bannerImage = null),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Expanded(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: MyColors.lightGray,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_rounded,
                    size: 32,
                    color: MyColors.lightGray,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Banner preview',
                    style: TextStyle(fontSize: 12, color: MyColors.lightGray),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
