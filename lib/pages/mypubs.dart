import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pfefront/blocs/announcement/car_announcement_bloc.dart';
import 'package:pfefront/data/models/announcement_model.dart';
import 'publier.dart';

class MyPubsPage extends StatefulWidget {
  final String currentUserId; // ID de l'utilisateur connecté

  const MyPubsPage({
    super.key,
    required this.currentUserId,
  });

  @override
  State<MyPubsPage> createState() => _MyPubsPageState();
}

class _MyPubsPageState extends State<MyPubsPage> {
  @override
  void initState() {
    super.initState();
    final userId = int.tryParse(widget.currentUserId); // Convertir en entier si nécessaire
    if (userId != null) {
      context.read<CarAnnouncementBloc>().add(FetchVendorAnnouncement(userId));
    } else {
      print('Erreur : userId est null ou invalide.');
    }
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmer la suppression',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer cette publication ?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text(
                'Annuler',
                style: GoogleFonts.poppins(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<CarAnnouncementBloc>().add(DeleteAnnouncement(id));
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text(
                'Supprimer',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF50C2C9),
                  Color.fromARGB(255, 235, 237, 243),
                  Color(0xFFE1F5F7),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    title: Text(
                      'Mes Publications',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Expanded(
                    child: BlocBuilder<CarAnnouncementBloc, CarAnnouncementState>(
                      builder: (context, state) {
                        if (state is VendorAnnouncementsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is VendorAnnouncementsLoaded) {
                          final announcements = state.announcements;

                          if (announcements.isEmpty) {
                            return Center(
                              child: Text(
                                'Aucune publication trouvée.',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: announcements.length,
                            itemBuilder: (context, index) {
                              final announcement = announcements[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 6,
                                  shadowColor: Colors.black.withOpacity(0.1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (announcement.imageUrl.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                          child: Image.network(
                                            announcement.imageUrl,
                                            height: 180,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              announcement.title,
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF333333),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Prix : ${announcement.price} €',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF50C2C9),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              announcement.description,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () async {
                                                    final updatedData = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PublierAnnoncePage(
                                                          publicationData: announcement.toJson(),
                                                        ),
                                                      ),
                                                    );
                                                    if (updatedData != null) {
                                                      setState(() {
                                                        // Mettre à jour l'annonce si nécessaire
                                                      });
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.blue,
                                                  ),
                                                  label: Text(
                                                    "Modifier",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                TextButton.icon(
                                                  onPressed: () {
                                                    if (announcement.id != null) {
                                                      _showDeleteDialog(announcement.id!);
                                                    } else {
                                                      print('Erreur : ID de l\'annonce est null.');
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  label: Text(
                                                    "Supprimer",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is VendorAnnouncementsError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                        return const Center(
                          child: Text('Aucune donnée disponible.'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PublierAnnoncePage(),
                  ),
                );
              },
              child: Lottie.asset(
                'assets/json/createpub.json',
                height: 80,
                width: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}