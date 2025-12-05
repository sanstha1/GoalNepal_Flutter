import 'package:flutter/material.dart';
import 'package:goal_nepal/widgets/my_button.dart';
// import 'register_screen.dart';

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
            colors: [
              Color(0xFF2E3134),
              Color(0xFF6F6F66),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // SIDE TEXT
              Positioned(
                left: -70,
                top: 120,
                child: Transform.rotate(
                  angle: -1.57,
                  child: const Text(
                    "Your Game, Your Platform.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // MAIN CONTENT
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // LOGO
                      Image.asset(
                        "assets/images/logo.png",
                        height: 120,
                      ),
                      const SizedBox(height: 20),

                      // TITLE
                      const Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Color(0xFFFDFCCB),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // EMAIL FIELD
                      _inputField("Enter your email"),

                      const SizedBox(height: 20),

                      // PASSWORD FIELD
                      _inputField("Enter your password", obscure: true),

                      const SizedBox(height: 10),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 35),
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
                      ),

                      const SizedBox(height: 30),

                      _divider(),

                      const SizedBox(height: 20),

                      _socialRow(),

                      const SizedBox(height: 30),

                      // SIGN UP
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

  // COMMON TEXTFIELD
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  // DIVIDER
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

  // SOCIAL ICON ROW
  Widget _socialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.person, size: 40, color: Colors.white), // replace with GitHub logo
        SizedBox(width: 25),
        Icon(Icons.person, size: 40, color: Colors.white), // replace with LinkedIn logo
      ],
    );
  }
}
