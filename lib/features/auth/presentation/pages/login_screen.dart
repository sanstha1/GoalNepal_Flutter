import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/features/auth/presentation/widgets/loginbutton.dart';
import 'package:goal_nepal/features/buttom_navigation/presentation/pages/buttom_navigation_screen.dart';
import 'package:goal_nepal/features/auth/presentation/pages/register_screen.dart';
import 'package:goal_nepal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:goal_nepal/features/auth/presentation/state/auth_state.dart';
import 'package:goal_nepal/core/utils/my_snackbar.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    /// Listen for auth changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        SnackbarUtils.showSuccess(context, "Login successful!");

        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ButtomNavigationScreen()),
            );
          }
        });
      }

      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(context, next.errorMessage ?? "Login failed");
      }
    });

    void handleLogin() {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        SnackbarUtils.showError(context, "Please fill all fields");
        return;
      }

      ref
          .read(authViewModelProvider.notifier)
          .login(email: email, password: password);
    }

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
                  Image.asset("assets/images/logo.png", height: 350),

                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Color(0xFFFDFCCB),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _inputField(
                    controller: _emailController,
                    hint: "Enter your email",
                  ),

                  const SizedBox(height: 20),

                  _inputField(
                    controller: _passwordController,
                    hint: "Enter your password",
                    obscure: true,
                  ),

                  const SizedBox(height: 10),

                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 41),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Loginbutton(
                    text: authState.status == AuthStatus.loading
                        ? "LOGGING IN..."
                        : "LOGIN",
                    onPressed: authState.status == AuthStatus.loading
                        ? () {}
                        : handleLogin,
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
                        "Don’t have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "  Sign Up",
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
        borderRadius: BorderRadius.circular(10),
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
