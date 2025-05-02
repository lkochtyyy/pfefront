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

class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  final CarAnnouncementRepository _carRepository = CarAnnouncementRepository(dio: Dio());

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
              print("te7cheeeeeeeeeeeeeeeee");
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriLoaded) {

              final carIds = state.favoris.map((f) => f.carId).toList();
              print("Favorite car IDs: $carIds");

              if (carIds.isEmpty) {
                print("te7cheeet");
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final car = cars[index];
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
                                    child: Image.network(
                                      car.imageFile != null
                                          ? car.imageFile!.path
                                          : car.imageUrl,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Icon(Icons.favorite, color: Colors.red),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                car.title,
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
                                  
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: car.carCondition == true ? Colors.grey[200] : Colors.black,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      (car.carCondition == true) ? "Used" : "New",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: car.carCondition == true ? Colors.black : Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "\$${car.price}",
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
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PublierAnnoncePage()));
            break;
          case 1:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FeaturedCarsPage()));
            break;
          case 2:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatsPage()));
            break;
        }
      },
      selectedLabelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }
}
