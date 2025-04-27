import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pfefront/blocs/auth/auth_bloc.dart';
import 'package:pfefront/blocs/auth/auth_event.dart';
import 'package:pfefront/blocs/auth/auth_state.dart';
import 'package:pfefront/data/models/announcement_model.dart';
import 'package:pfefront/pages/editer.dart';
import 'package:pfefront/pages/mypubs.dart';
import 'package:pfefront/pages/user_avatar_provider.dart';
import 'package:pfefront/utils/shared_prefs_helper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Animation d'opacité
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() => _opacity = 1.0);
    });
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = await SharedPrefsHelper.getUserId();
    if (userId != null) {
      // On dispatch l'événement pour charger le profil
      context.read<AuthBloc>().add(FetchUserProfile(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
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
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: _opacity,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar animé
                    ValueListenableBuilder<String?>(
                      valueListenable: UserAvatar.avatarPath,
                      builder: (context, avatar, _) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: CircleAvatar(
                            key: ValueKey<String?>(avatar),
                            radius: 45,
                            backgroundColor: const Color(0xFF50C2C9),
                            backgroundImage:
                                avatar != null ? AssetImage(avatar) : null,
                            child: avatar == null
                                ? const Icon(Icons.person,
                                    size: 60,
                                    color: Color.fromARGB(255, 7, 8, 8))
                                : null,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nom dynamiquement via BLoC
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is UserProfileLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is UserProfileLoaded) {
                          return Text(
                            'Hello, ${state.user.nom}!',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black87,
                            ),
                          );
                        } else if (state is UserProfileError) {
                          return Text(
                            'Erreur: ${state.message}',
                            style: GoogleFonts.poppins(color: Colors.red),
                          );
                        }
                        return Text(
                          'Hello, User!',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black87,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'What would you like to do today?',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'My Profile',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
                buildOptionTile(
                context,
                Icons.settings,
                'Détails personnelles',
                () async {
                  final userId = await SharedPrefsHelper.getUserId();
                  if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => UserAccountPage(),
                    ),
                  );
                  }
                },
              ),
              buildOptionTile(
                context,
                Icons.notifications,
                'Mes publications',
                () async {
                  final userId = await SharedPrefsHelper.getUserId();
                  if (userId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPubsPage(
                         
                          currentUserId: userId,
                        ),
                      ),
                    );
                  } else {
                    // Handle the case where userId is null
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User ID not found')),
                    );
                  }
                },
              ),

              const SizedBox(height: 40),

              // Email dynamiquement via BLoC
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is UserProfileLoaded) {
                    return Center(
                      child: Text(
                        'Logged in as ${state.user.email}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),

              const SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // ici tu peux clear SharedPrefs et rediriger vers login
                    SharedPrefsHelper.clearSession();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (_) => false);
                  },
                  icon: const Icon(Icons.logout, color: Color(0xFF50C2C9)),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF50C2C9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF50C2C9)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF50C2C9)),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
      ),
    );
  }
}
