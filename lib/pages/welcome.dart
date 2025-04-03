import 'package:flutter/material.dart';
import 'package:pfefront/pages/login.dart' as login_page;
import 'package:pfefront/pages/signupscreen.dart' as signup_page;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3), // Background color
      body: Stack(
        children: [
          // Background shape (Make sure it's visible and adjust the positioning)
          Positioned(
            top: -size.height * 0.05,
            left: -size.width * 0.05,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/shape.png', // Path to your shape.png image
                width: size.width * 0.6,
                fit: BoxFit.cover, // Adjust to fit the screen
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.25),

                // Illustration
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Image.asset(
                      'assets/group.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                
                // Buttons section
                Padding(
                  padding: EdgeInsets.only(
                    bottom: size.height * 0.08,
                    top: size.height * 0.05,
                    left: 60,
                    right: 60,
                  ),
                  child: Column(
                    children: [
                      _AuthButton(
                        text: 'Se Connecter',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const login_page.LoginPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _AuthButton(
                        text: 'S\'inscrire',
                        isPrimary: false,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => signup_page.RegisterPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _AuthButton({
    required this.text,
    this.isPrimary = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF50C2C9) : Colors.white, // Couleur de fond
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF50C2C9), // Couleur du texte
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: Color(0xFF50C2C9), width: 2.0),
          ),
          minimumSize: const Size(double.infinity, 60), // Taille identique
          elevation: 6, // Ombre comme le bouton Login
          shadowColor: Colors.black26, // Ombre douce
        ),
        child: Text(
          text,
          textAlign: TextAlign.center, // Alignement parfait du texte
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
