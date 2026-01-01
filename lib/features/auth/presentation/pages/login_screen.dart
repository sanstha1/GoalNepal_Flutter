import 'package:flutter/material.dart';
import 'package:goal_nepal/features/buttom_navigation/presentation/pages/buttom_navigation_screen.dart';
import 'package:goal_nepal/features/auth/presentation/pages/register_screen.dart';
import 'package:goal_nepal/features/dashboard/presentation/widgets/my_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset("assets/images/logo.png", height: 350),
                      const SizedBox(height: 0),

                      const Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Color(0xFFFDFCCB),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      _inputField("Enter your email"),

                      const SizedBox(height: 20),

                      _inputField("Enter your password", obscure: true),

                      const SizedBox(height: 10),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 65),
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

                      MyButton(
                        text: "LOGIN",
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ButtomNavigationScreen(),
                            ),
                          );
                        },
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hint, {bool obscure = false}) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
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
          child: Image.asset('assets/icons/github.png', width: 40, height: 40),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () {},
          child: Image.asset('assets/icons/google.png', width: 40, height: 40),
        ),
      ],
    );
  }
}
