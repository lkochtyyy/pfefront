import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/blocs/auth/auth_bloc.dart';
import 'package:pfefront/blocs/auth/auth_event.dart';
import 'package:pfefront/blocs/auth/auth_state.dart';
import 'package:pfefront/pages/adressupdate.dart';
import 'package:pfefront/pages/emailupdate.dart';
import 'package:pfefront/pages/mdpupdate.dart';
import 'package:pfefront/pages/nameupdate.dart';
import 'package:pfefront/pages/phonenumberupdate.dart';
import 'package:pfefront/pages/profilepicture.dart';
import 'package:pfefront/utils/shared_prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfefront/data/models/user_model.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfefront/pages/welcome.dart';


class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});


  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}


class _UserAccountPageState extends State<UserAccountPage> {
  double opacity = 0.0;
  String? selectedAvatarPath;


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => opacity = 1.0);
    });
    _loadAvatar();
    _loadUserProfile();
  }


  Future<void> _loadAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt('selected_avatar');
    if (index != null) {
      setState(() {
        selectedAvatarPath = 'assets/avatars/avatar_${index + 1}.png';
      });
    }
  }


  Future<void> _loadUserProfile() async {
    final userId = await SharedPrefsHelper.getUserId();
    if (userId != null) {
      context.read<AuthBloc>().add(FetchUserProfile(userId));
    }
  }


  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent, // Rendre le fond transparent
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Rendre l'AppBar transparente
          elevation: 0, // Supprimer l'ombre de l'AppBar
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'User Account',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body:BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is UserDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account deleted successfully.',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );

      // Rediriger vers la page WelcomeScreen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false, // Supprime toutes les pages précédentes de la pile
      );
    } else if (state is UserProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    if (state is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is UserProfileLoaded) {
      final user = state.user;
      return _buildUserProfile(user);
    } else if (state is UserProfileError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const Center(child: Text('No user data available.'));
  },
),
      ),
    );
  }


  Widget _buildUserProfile(UserModel user) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: opacity,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          sectionTitle('Profile Information'),
          cardContainer(
            child: ListTile(
              leading: selectedAvatarPath != null
                  ? CircleAvatar(
                      backgroundImage: AssetImage(selectedAvatarPath!),
                    )
                  : const Icon(Icons.person),
              title: Text(
                'Profile Picture',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              subtitle: Text(
                '(Only visible for you)',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilePictureScreen()),
                );
                _loadAvatar();
              },
            ),
          ),
          const SizedBox(height: 16),
          sectionTitle('Login'),
          cardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoTile(
                  Icons.email,
                  'E-Mail',
                  user.email,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmailUpdatePage()),
                  ),
                ),
                const Divider(),
                infoTile(
                  Icons.lock,
                  'Password',
                  '********',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PasswordUpdateUser()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          sectionTitle('Contact'),
          cardContainer(
            child: Column(
              children: [
                infoTile(
                  Icons.person_outline,
                  'Name',
                  user.nom,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NameUser()),
                  ),
                ),
                const Divider(),
                infoTile(
                  Icons.location_on,
                  'Address',
                  'adress',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddressUser()),
                  ),
                ),
                const Divider(),
                infoTile(
                  Icons.phone,
                  'Telephone Number',
                  user.tel ?? 'No information available',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NumberUpdatePage()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever),
              label: Text(
                'Delete Account',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _showDeleteDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }


  void _showDeleteDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Confirm Deletion",
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Confirm Deletion', style: GoogleFonts.poppins()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/json/delete.json',
                    height: 150, width: 150),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to delete your account?\nThis action cannot be undone.',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize:
                        16, // Ajout d'une taille de police pour mieux contrôler l'affichage
                    fontWeight: FontWeight
                        .w500, // Optionnel : un poids de texte pour plus de lisibilité
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel',
                    style: GoogleFonts.poppins(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  Navigator.of(context).pop(); // Ferme le premier dialog


                  // Affiche le dialog de "suppression en cours"
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierLabel: "Deleting...",
                    barrierColor: Colors.black.withOpacity(0.5),
                    pageBuilder: (context, anim1, anim2) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 20),
                              Text(
                                'Suppression en cours...',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );


                  // Déclenche la suppression ici
                  final userId = await SharedPrefsHelper.getUserId();
                  if (userId != null) {
                    context.read<AuthBloc>().add(DeleteUser(userId));
                  }


                  // Attends 2 secondes
                  await Future.delayed(const Duration(seconds: 2));


                  // Ferme le dialog de chargement
                  Navigator.of(context).pop();


                  // Affiche le dialog de succès
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierLabel: "Account Deleted",
                    barrierColor: Colors.black.withOpacity(0.5),
                    pageBuilder: (context, anim1, anim2) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text('Account Deleted',
                              style: GoogleFonts.poppins()),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset('assets/json/donedelete.json',
                                  height: 150, width: 150),
                              const SizedBox(height: 10),
                              const Text(
                                'Your account has been successfully deleted.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );


                  // Attends encore 2 secondes avant d'aller vers WelcomeScreen
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.of(context).pop(); // Ferme le dialog de succès
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                child: Text('Delete',
                    style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }


  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
    );
  }


  Widget cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }


  Widget infoTile(IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                          color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}



