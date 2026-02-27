import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/features/register/presentation/state/register_state.dart';
import 'package:goal_nepal/features/register/presentation/view_model/register_viewmodel.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';

void showRegistrationBottomSheet({
  required BuildContext context,
  required TournamentEntity tournament,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RegistrationBottomSheet(tournament: tournament),
  );
}

class RegistrationBottomSheet extends ConsumerStatefulWidget {
  final TournamentEntity tournament;

  const RegistrationBottomSheet({super.key, required this.tournament});

  @override
  ConsumerState<RegistrationBottomSheet> createState() =>
      _RegistrationBottomSheetState();
}

class _RegistrationBottomSheetState
    extends ConsumerState<RegistrationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _captainNameController = TextEditingController();
  final _captainPhoneController = TextEditingController();
  final _captainEmailController = TextEditingController();
  final _playerCountController = TextEditingController();

  @override
  void dispose() {
    _teamNameController.dispose();
    _captainNameController.dispose();
    _captainPhoneController.dispose();
    _captainEmailController.dispose();
    _playerCountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(registrationViewModelProvider.notifier)
        .registerForTournament(
          tournamentId: widget.tournament.tournamentId!,
          tournamentTitle: widget.tournament.title,
          teamName: _teamNameController.text.trim(),
          captainName: _captainNameController.text.trim(),
          captainPhone: _captainPhoneController.text.trim(),
          captainEmail: _captainEmailController.text.trim(),
          playerCount: int.parse(_playerCountController.text.trim()),
        );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ref.read(registrationViewModelProvider.notifier).reset();
      _showSuccessDialog(context, widget.tournament.title);
    }
  }

  void _showSuccessDialog(BuildContext context, String tournamentTitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(tournamentTitle: tournamentTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationViewModelProvider);
    final isLoading = state.status == RegistrationStatus.loading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.emoji_events, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Register for ${widget.tournament.title}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.tournament.location} · ${_formatDate(widget.tournament.startDate)} – ${_formatDate(widget.tournament.endDate)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Divider(height: 28),
              _buildField(
                controller: _teamNameController,
                label: 'Team Name',
                hint: 'e.g. Eagles FC',
                icon: Icons.group,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Team name is required'
                    : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _captainNameController,
                label: 'Captain Name',
                hint: 'Full name',
                icon: Icons.person,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Captain name is required'
                    : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _captainPhoneController,
                label: 'Captain Phone',
                hint: '98XXXXXXXX',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Phone is required';
                  if (v.trim().length < 10) return 'Enter a valid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _captainEmailController,
                label: 'Captain Email',
                hint: 'email@example.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _playerCountController,
                label: 'Number of Players',
                hint: widget.tournament.type == TournamentType.futsal
                    ? 'e.g. 5'
                    : 'e.g. 11',
                icon: Icons.sports_soccer,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Player count is required';
                  }
                  final n = int.tryParse(v.trim());
                  if (n == null || n < 1) return 'Enter a valid number';
                  return null;
                },
              ),
              if (state.status == RegistrationStatus.error) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage ?? 'Something went wrong',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Submit Registration',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) => '${d.day} ${_monthName(d.month)} ${d.year}';

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

class _SuccessDialog extends StatelessWidget {
  final String tournamentTitle;

  const _SuccessDialog({required this.tournamentTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 38),
            ),
            const SizedBox(height: 20),
            const Text(
              'Registration Submitted!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Your team has been successfully registered for "$tournamentTitle". The organizer will review your registration.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
