import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';


class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});


  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Nouvelle annonce publiée',
        'description': 'Votre annonce a été publiée avec succès.',
        'lottie': 'assets/json/newpub.json',
        'time': 'Il y a 5 minutes',
        'unread': true,
      },
      {
        'title': 'Message reçu',
        'description': 'Vous avez reçu un nouveau message.',
        'lottie': 'assets/json/checkmessages.json',
        'time': 'Il y a 10 minutes',
        'unread': true,
      },
      {
        'title': 'Mise à jour de l\'annonce',
        'description': 'Votre annonce a été mise à jour.',
        'lottie': 'assets/json/updateannounce.json',
        'time': 'Il y a 1 heure',
        'unread': false,
      },
    ];


    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final bool unread = notification['unread'] ?? false;


            return Animate(
              effects: [
                FadeEffect(duration: 500.ms),
                SlideEffect(
                  duration: 500.ms,
                  begin: const Offset(0, 0.1),
                  curve: Curves.easeOut,
                )
              ],
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: unread
                            ? const Color(0xFF50C2C9).withOpacity(0.3)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Lottie.asset(
                                notification['lottie'],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification['description'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    notification['time'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (unread)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        height: 22,
                        width: 22,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ).animate().scale(duration: 400.ms),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



