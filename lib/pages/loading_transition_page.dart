import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

import 'pagedacceuil.dart';

class LoadingTransitionPage extends StatefulWidget {
  final int userId;

  const LoadingTransitionPage({super.key, required this.userId});

  @override
  State<LoadingTransitionPage> createState() => _LoadingTransitionPageState();
}

class _LoadingTransitionPageState extends State<LoadingTransitionPage>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _bubbleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _scaleController.forward();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => FeaturedCarsPage(),
          transitionsBuilder: (_, animation, __, child) {
            final curved =
                CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé animé
          AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [Color(0xFFB5F2EA), Color(0xFFE5D5F9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.5 + 0.2 * sin(_bubbleController.value * 2 * pi),
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),

          // Bulles flottantes animées
          CustomPaint(
            size: screen,
            painter: _BubblePainter(_bubbleController),
          ),

          // Contenu principal centré
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'helloAnimation',
                    child: Lottie.asset(
                      'assets/json/hello.json',
                      width: 260,
                      height: 260,
                      repeat: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _scaleController.value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - _scaleController.value)),
                          child: Text(
                            'Bienvenue chez CARZone 🚗',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Peinture des bulles flottantes
class _BubblePainter extends CustomPainter {
  final Animation<double> animation;
  final List<Offset> positions = List.generate(15, (_) => Offset.zero);
  final Random random = Random();

  _BubblePainter(this.animation) : super(repaint: animation) {
    for (int i = 0; i < positions.length; i++) {
      positions[i] = Offset(random.nextDouble(), random.nextDouble());
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.15);
    for (final pos in positions) {
      final dx = pos.dx * size.width;
      final dy = (pos.dy + animation.value) % 1.0 * size.height;
      final radius = 10 + random.nextDouble() * 20;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) => true;
}
