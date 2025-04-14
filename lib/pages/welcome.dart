import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfefront/pages/login.dart' as login_page;
import 'package:pfefront/pages/signupscreen.dart' as signup_page;
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF50C2C9),
              Color.fromARGB(255, 235, 237, 243),
              Color(0xFFE1F5F7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Image de fond avec animation

            // Contenu principal
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.25),

                  // Image de groupe avec animation
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Image.asset(
                        'assets/group.png',
                        fit: BoxFit.contain,
                      )
                          .animate()
                          .fade(duration: 800.ms)
                          .slideY(begin: -0.2), // Animation de fade et slide
                    ),
                  ),

                  // Section des boutons avec padding et marges ajustées
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
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const login_page.LoginPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                            ),
                          ),
                        ).animate().fade(duration: 400.ms).slideY(
                            begin:
                                0.2), // Animation de fade et slide pour le bouton
                        const SizedBox(height: 20),
                        _AuthButton(
                          text: 'S\'inscrire',
                          isPrimary: false,
                          onPressed: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const signup_page.RegisterPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                            ),
                          ),
                        ).animate().fade(duration: 400.ms).slideY(
                            begin:
                                0.2), // Animation de fade et slide pour le bouton
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          backgroundColor: isPrimary ? const Color(0xFF50C2C9) : Colors.white,
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF50C2C9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: Color(0xFF50C2C9), width: 2.0),
          ),
          minimumSize: const Size(double.infinity, 60),
          elevation: 6,
          shadowColor: Colors.black26,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
