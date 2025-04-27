import 'dart:convert';
import 'dart:io';
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
  final String annonceId; // Receive the car ID

  const CarDetailPage({super.key, required this.annonceId, });

  @override
  _CarDetailPageState createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  late Future<CarAnnouncement> _carFuture;
  int _currentImageIndex = 0;
  double _currentRating = 4.5; // Default rating

  @override
  void initState() {
    super.initState();
    _carFuture = _fetchCarDetails();
  }

  Future<CarAnnouncement> _fetchCarDetails() async {
    ;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/carAnnouncement/${widget.annonceId}'),
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
                      // Header with back button
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

                      // Hero image for smooth transition
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

                      // Title and model
                      Text(
                        "${car.brand} ${car.model}",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "${car.year} • ${car.fuelType} • ${car.mileage} km",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Price and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "€$priceFormatted",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                _currentRating.toStringAsFixed(1),
                                style: GoogleFonts.poppins(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Car specs card
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSpecsItem(Icons.speed, "Kilométrage", "${car.mileage} km"),
                                  _buildSpecsItem(Icons.calendar_today, "Année", "${car.year}"),
                                  _buildSpecsItem(Icons.build, "État", car.carCondition),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSpecsItem(Icons.local_gas_station, "Carburant", car.fuelType),
                                  _buildSpecsItem(Icons.settings, "Boîte", "Automatique"), // Add transmission if available
                                  _buildSpecsItem(Icons.location_on, "Localisation", car.location),
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

  Widget _buildSpecsItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.teal),
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