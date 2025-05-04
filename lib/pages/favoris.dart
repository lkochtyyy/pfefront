import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pfefront/blocs/favoris/favori_bloc.dart';
import 'package:pfefront/blocs/favoris/favori_state.dart';
import 'package:pfefront/data/models/announcement_model.dart';
import 'package:pfefront/data/repositories/announcement_repository.dart';
import 'package:dio/dio.dart';

import 'package:pfefront/pages/messagerie.dart';
import 'package:pfefront/pages/publier.dart';
import 'package:pfefront/pages/pagedacceuil.dart';
import 'package:pfefront/pages/viewpub.dart';
import 'package:pfefront/pages/viewpub.dart';

class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  final CarAnnouncementRepository _carRepository =
      CarAnnouncementRepository(dio: Dio());

  Future<List<CarAnnouncement>> _loadFavoriteCars(List<int> carIds) async {
    print("Fetching cars for IDs: $carIds");
    List<CarAnnouncement> cars = [];
    for (var carId in carIds) {
      try {
        final car = await _carRepository.fetchById(carId);
        print("Car fetched: $car");
        cars.add(car);
      } catch (e) {
        print("Error loading car $carId: $e");
      }
    }
    return cars;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.only(top: 100, left: 12, right: 12),
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
        child: BlocBuilder<FavoriBloc, FavoriState>(
          builder: (context, state) {
            if (state is FavoriLoading) {
              print("Erreur");
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriLoaded) {
              final carIds = state.favoris.map((f) => f.carId).toList();
              print("Favorite car IDs: $carIds");

              if (carIds.isEmpty) {
                print("Erreur");
                return _buildEmptyWidget();
              }

              return FutureBuilder<List<CarAnnouncement>>(
                future: _loadFavoriteCars(carIds),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erreur: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyWidget();
                  }

                  final cars = snapshot.data!;

                  return GridView.builder(
                    itemCount: cars.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      final imageUrl = car.imageUrl;
                      return CarCard(
                        data: {
                          'id': car.id,
                          'title': car.title,
                          'price': car.price,
                          'status': car.carCondition,
                          'image': imageUrl,
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CarDetailPage(annonceId: '${car.id}'),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return _buildEmptyWidget();
            }
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/json/favoris.json', width: 250),
          const SizedBox(height: 20),
          Text(
            "No favorites yet!",
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            "Add cars to your wishlist to see them here.",
            style: GoogleFonts.poppins(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Publier',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email_rounded),
          label: 'Messagerie',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars_rounded),
          label: 'Favoris',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const PublierAnnoncePage()));
            break;
          case 1:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const FeaturedCarsPage()));
            break;
          case 2:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const ChatsPage()));
            break;
        }
      },
      selectedLabelStyle:
          GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }
}

class CarCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const CarCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final image = data['image'] as String;
    final priceFormatted = "\$${data['price'].toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.45, // Limit card width
        ),
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
          mainAxisSize: MainAxisSize.min, // Important to prevent overflow
          children: [
            // Image container with fixed aspect ratio
            AspectRatio(
              aspectRatio: 1.5,
              child: Hero(
                tag: 'car-image-${data['id']}',
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: image.startsWith('http')
                          ? Image.network(
                              image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Title with max lines
            Text(
              data['title'],
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Rating and status row
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  "4.5",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(width: 6),
                const Text(
                  "|",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 9),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(data['status']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      data['status'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusTextColor(data['status']),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Price with better formatting
            Text(
              priceFormatted,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue.shade100;
      case 'used':
        return Colors.grey.shade300;
      case 'certified':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue.shade800;
      case 'used':
        return Colors.black87;
      case 'certified':
        return Colors.green.shade800;
      default:
        return Colors.black87;
    }
  }
}
