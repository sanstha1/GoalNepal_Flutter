import 'package:flutter/material.dart';
import 'package:goal_nepal/widgets/my_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E3134),
              Color(0xFF6F6F66),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 280,
                      ),
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

                      _inputField("Full Name"),
                      const SizedBox(height: 18),

                      _inputField("Email"),
                      const SizedBox(height: 18),

                      _inputField("Password", obscure: true),
                      const SizedBox(height: 18),

                      _inputField("Confirm Password", obscure: true),
                      const SizedBox(height: 30),

                      MyButton(
                        text: "SIGN UP",
                        onPressed: () {},
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
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
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
              )
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        const SizedBox(width: 50),
        Expanded(
          child: Container(height: 1, color: Colors.white38),
        ),
        const Text("  OR  ", style: TextStyle(color: Colors.white70)),
        Expanded(
          child: Container(height: 1, color: Colors.white38),
        ),
        const SizedBox(width: 50),
      ],
    );
  }

  Widget _socialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {

          },
          child: Image.asset(
            'assets/icons/github.png',
            width: 40,
            height: 40,
          ),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () {

          },
          child: Image.asset(
            'assets/icons/google.png',
            width: 40,
            height: 40,
          ),
        ),
      ],
    );
  }
}
