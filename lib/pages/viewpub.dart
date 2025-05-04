import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pfefront/data/models/announcement_model.dart';
import 'package:http/http.dart' as http;

class CarDetailPage extends StatefulWidget {
  final String annonceId;

  const CarDetailPage({
    super.key,
    required this.annonceId,
  });

  @override
  _CarDetailPageState createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  late Future<CarAnnouncement> _carFuture;
  int _currentImageIndex = 0;
  double _currentRating = 4.5;
  double _userRating = 0;

  @override
  void initState() {
    super.initState();
    _carFuture = _fetchCarDetails();
  }

  Future<CarAnnouncement> _fetchCarDetails() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.8:3000/carAnnouncement/${widget.annonceId}'),
    );

    if (response.statusCode == 200) {
      return CarAnnouncement.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load car details');
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 10),
            Text("Message envoyé", style: GoogleFonts.poppins()),
          ],
        ),
        content: Text(
          "Votre message a bien été envoyé au vendeur.",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: GoogleFonts.poppins(color: Colors.orange)),
          )
        ],
      ),
    );
  }

  void _showRatingConfirmation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Merci pour votre avis !", style: GoogleFonts.poppins()),
        content: Text(
          "Vous avez donné une note de $_userRating étoiles.",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text("Fermer", style: GoogleFonts.poppins(color: Colors.teal)),
          )
        ],
      ),
    );
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation
            SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset(
                  'assets/json/rating.json'), // Remplacez par le chemin de votre fichier Lottie
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              "Merci de votre contribution",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle

            const SizedBox(height: 20),
            // Single Button: Terminer
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer le dialog
              },
              child: Text(
                "Terminer",
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 164, 68, 223),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CarAnnouncement>(
        future: _carFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final car = snapshot.data!;
          final priceFormatted = car.price.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (match) => '${match[1]},',
              );

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF50C2C9),
                  Color.fromARGB(255, 235, 237, 243),
                  Color(0xFFE1F5F7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          Text(
                            car.brand,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.star, color: Colors.amber),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Image
                      Hero(
                        tag: 'car-image-${car.id}',
                        child: Container(
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(car.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${car.brand} ${car.model}",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Lottie Animation
                              SizedBox(
                                height:
                                    50, // Ajustez la taille selon vos besoins
                                width: 50,
                                child: Lottie.asset(
                                  'assets/json/options.json', // Remplacez par le chemin de votre fichier Lottie
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      4), // Espacement entre l'animation et le texte

                              // Texte "Options"
                              Text(
                                "Options :",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      8), // Espacement entre "Options" et les options dynamiques

                              // Options dynamiques
                              Expanded(
                                child: Text(
                                  "${car.options}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Price & rating
                      Row(
                        children: [
                          // Lottie Animation

                          const SizedBox(
                              width:
                                  4), // Espacement entre l'animation et le texte

                          // Prix formaté
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Lottie Animation
                              SizedBox(
                                height:
                                    50, // Ajustez la taille selon vos besoins
                                width: 50,
                                child: Lottie.asset(
                                  'assets/json/price.json', // Remplacez par le chemin de votre fichier Lottie
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      3), // Espacement entre la Lottie et le texte

                              // Texte à gauche
                              Text(
                                "Prix :",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      8), // Espacement entre le texte et le prix

                              // Prix formaté
                              Text(
                                "$priceFormatted DT",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Car Specs
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSpecsItem('assets/json/kilo.json',
                                      "Kilométrage", "${car.mileage} km"),
                                  _buildSpecsItem('assets/json/year.json',
                                      "Année", "${car.year}"),
                                  _buildSpecsItem('assets/json/carinfo.json',
                                      "État", car.carCondition),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSpecsItem('assets/json/fuuel.json',
                                      "Carburant", car.fuelType),
                                  _buildSpecsItem('assets/json/gearbox.json',
                                      "Boîte", "Automatique"),
                                  _buildSpecsItem('assets/json/place.json',
                                      "Localisation", car.location),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                car.description,
                                style: GoogleFonts.poppins(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Rating Bar
                      // Rating Bar Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre "Notez ce véhicule"
                          Text(
                            "Notez ce véhicule",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Barre de notation et bouton "Publier l'avis"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Barre de notation
                              Expanded(
                                child: RatingBar.builder(
                                  initialRating: _userRating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _userRating = rating;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Bouton "Publier l'avis"
                              ElevatedButton(
                                onPressed: _userRating == 0
                                    ? null
                                    : _showThankYouDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                      255, 86, 23, 126), // Nouvelle couleur
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Publier",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Contact button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _showConfirmationDialog,
                          child: Text(
                            "Contacter le vendeur",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecsItem(String lottiePath, String title, String value) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: Lottie.asset(
            lottiePath,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.poppins(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
