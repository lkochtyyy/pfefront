import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfefront/pages/messagerie.dart';
import 'package:pfefront/pages/publier.dart';
import 'package:pfefront/pages/search.dart';
import 'package:pfefront/pages/pagedacceuil.dart';
import 'package:lottie/lottie.dart';

class FavorisPage extends StatelessWidget {
  FavorisPage({super.key});

  // Define a list of favorite cars
  final List<Map<String, dynamic>> voituresFavorites = [];

  @override
  Widget build(BuildContext context) {
    final bool favorisVides = voituresFavorites.isEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "My Wishlist",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
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
        padding: const EdgeInsets.only(top: 100, left: 12, right: 12),
        child: favorisVides
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/json/favoris.json', // 💡 ton fichier Lottie
                      width: 250,
                      repeat: true,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No favorites yet!",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add cars to your wishlist to see them here.",
                      style: GoogleFonts.poppins(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : GridView.builder(
                itemCount: voituresFavorites.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final car = voituresFavorites[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  car["image"],
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const Positioned(
                                top: 0,
                                right: 0,
                                child: Icon(Icons.favorite_border),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            car["title"],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                car["rating"].toString(),
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: car["isUsed"]
                                      ? Colors.grey[200]
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  car["isUsed"] ? "Used" : "New",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: car["isUsed"]
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "\$${car["price"]}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF50C2C9),
      unselectedItemColor: Colors.black.withOpacity(0.6),
      showUnselectedLabels: true,
      elevation: 12,
      iconSize: 30,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      currentIndex: 3,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.directions_car),
          label: 'Publier',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.email_rounded),
          label: 'Messagerie',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.stars_rounded),
          label: 'Favoris',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const PublierAnnoncePage()),
            );
            break;

          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const FeaturedCarsPage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatsPage()),
            );
            break;
        }
      },
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

// Fonction pour appliquer une animation douce aux icônes
  Widget _buildAnimatedIcon(IconData iconData) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: 1.2, // Agrandissement de l'icône sélectionnée
      child: Icon(
        iconData, size: 30, color: const Color(0xFF50C2C9), // Icône agrandie
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final Map<String, dynamic> car;
  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    car['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            car['title'],
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              const Text(
                "4.5",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 6),
              const Text(
                "|",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(width: 9),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  car['status'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "\$${car['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
