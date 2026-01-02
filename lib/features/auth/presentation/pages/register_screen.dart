import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/features/auth/presentation/widgets/loginbutton.dart';
import 'package:goal_nepal/features/auth/presentation/pages/login_screen.dart';
import 'package:goal_nepal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:goal_nepal/features/auth/presentation/state/auth_state.dart';
import 'package:goal_nepal/core/utils/my_snackbar.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMySnackBar(
        context: context,
        message: "Please fill all fields",
        color: Colors.red,
      );
      return;
    }

    if (password != confirmPassword) {
      showMySnackBar(
        context: context,
        message: "Passwords do not match",
        color: Colors.red,
      );
      return;
    }

    ref
        .read(authViewModelProvider.notifier)
        .register(
          fullName: fullName,
          email: email,
          password: password,
          fullname: 'fullName',
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    /// Listen for auth changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        showMySnackBar(
          context: context,
          message: "Registration successful! Please login.",
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          }
        });
      }

      if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: next.errorMessage ?? "Registration failed",
          color: Colors.red,
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E3134), Color(0xFF6F6F66)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("assets/images/logo.png", height: 280),

                  const SizedBox(height: 10),

                  const Text(
                    "Register",
                    style: TextStyle(
                      color: Color(0xFFFDFCCB),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _inputField(
                    controller: _fullNameController,
                    hint: "Full Name",
                  ),

                  const SizedBox(height: 18),

                  _inputField(controller: _emailController, hint: "Email"),

                  const SizedBox(height: 18),

                  _inputField(
                    controller: _passwordController,
                    hint: "Password",
                    obscure: true,
                  ),

                  const SizedBox(height: 18),

                  _inputField(
                    controller: _confirmPasswordController,
                    hint: "Confirm Password",
                    obscure: true,
                  ),

                  const SizedBox(height: 30),

                  Loginbutton(
                    text: authState.status == AuthStatus.loading
                        ? "SIGNING UP..."
                        : "SIGN UP",
                    onPressed: authState.status == AuthStatus.loading
                        ? () {}
                        : _handleRegister,
                  ),

                  const SizedBox(height: 30),

                  _divider(),
                  const SizedBox(height: 20),

                  _socialRow(),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        child: const Text(
                          "  LOG IN",
                          style: TextStyle(
                            color: Color(0xFFFDFCCB),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) {
    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        const SizedBox(width: 50),
        Expanded(child: Container(height: 1, color: Colors.white38)),
        const Text("  OR  ", style: TextStyle(color: Colors.white70)),
        Expanded(child: Container(height: 1, color: Colors.white38)),
        const SizedBox(width: 50),
      ],
    );
  }

  Widget _socialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Image.asset('assets/icons/github.png', width: 40),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () {},
          child: Image.asset('assets/icons/google.png', width: 40),
        ),
      ],
    );
  }
}
