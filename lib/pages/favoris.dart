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

  Future<void> _showSortOptions(BuildContext context) async {
    final List<Map<String, dynamic>> sortOptions = [
      {"label": "Prix (croissant)", "icon": Icons.arrow_upward},
      {"label": "Prix (décroissant)", "icon": Icons.arrow_downward},
      {"label": "Marque A - Z", "icon": Icons.sort_by_alpha},
      {"label": "Marque Z - A", "icon": Icons.sort_by_alpha_outlined},
    ];

    String selectedOption = "Prix (croissant)";

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.55,
                maxChildSize: 0.8,
                minChildSize: 0.4,
                builder: (context, scrollController) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeOut,
                    )),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: ModalRoute.of(context)!.animation!,
                        curve: Curves.easeIn,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // Fond clair élégant
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(30)),
                        ),
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Center(
                              child: Container(
                                width: 50,
                                height: 5,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Trier par",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...sortOptions.map((option) {
                              final isSelected =
                                  selectedOption == option['label'];
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    selectedOption = option['label'];
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF50C2C9)
                                            .withOpacity(0.1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF50C2C9)
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(option['icon'],
                                          color: isSelected
                                              ? const Color(0xFF50C2C9)
                                              : Colors.black54),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          option['label'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: isSelected
                                                ? Colors.black
                                                : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check,
                                          color: const Color.fromARGB(
                                              255, 159, 80, 201),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.grey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 12),
                                  ),
                                  child: Text(
                                    "Annuler",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, selectedOption);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 159, 80, 201),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 12),
                                  ),
                                  child: Text(
                                    "Appliquer",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      _applySort(result); // Appliquer le tri avec l’option choisie
    }
  }

  void _applySort(String selectedOption) {
    print("Selected sort option: $selectedOption");
    // Implémentez ici la logique pour trier les favoris
    // Exemple : Trier la liste des voitures en fonction de l'option sélectionnée
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Car Park",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _showSortOptions(context); // Afficher la modal de tri
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Lottie.asset(
                  'assets/json/sort.json', // Chemin vers le fichier Lottie
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriLoaded) {
              final carIds = state.favoris.map((f) => f.carId).toList();
              if (carIds.isEmpty) {
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
                  return ListView.builder(
                    itemCount: cars.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return CarCard(
                        data: {
                          'id': car.id,
                          'title': car.title,
                          'price': car.price,
                          'status': car.carCondition,
                          'image': car.imageUrl,
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
      selectedItemColor: const Color.fromARGB(255, 11, 15, 15),
      unselectedItemColor: Colors.black.withOpacity(0.6),
      showUnselectedLabels: true,
      elevation: 12,
      iconSize: 30,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      currentIndex: 3, // Index de l'élément sélectionné
      items: [
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 40,
            width: 40,
            child: Lottie.asset(
              'assets/json/publishing.json',
              fit: BoxFit.contain,
            ),
          ),
          label: 'Vendre',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 40,
            width: 40,
            child: Lottie.asset(
              'assets/json/home.json',
              fit: BoxFit.contain,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 40,
            width: 40,
            child: Lottie.asset(
              'assets/json/texting.json',
              fit: BoxFit.contain,
            ),
          ),
          label: 'Messagerie',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 40,
            width: 40,
            child: Lottie.asset(
              'assets/json/parking.json',
              fit: BoxFit.contain,
            ),
          ),
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
          case 3:
            // Rester sur la page actuelle
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

  const CarCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final image = 'http://192.168.0.8:3000/fetchCarImages/${data['image']}';
    final priceFormatted = "\$${data['price'].toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Hero(
                    tag: 'car_${data['id']}',
                    child: Image.network(
                      image,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.red,
                      onPressed: () {
                        // TODO: Add favorite logic
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                data['title'],
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    priceFormatted,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(data['status']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data['status'].toString().toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusTextColor(data['status']),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue.shade50;
      case 'used':
        return Colors.orange.shade50;
      case 'certified':
        return Colors.green.shade50;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue.shade700;
      case 'used':
        return Colors.orange.shade700;
      case 'certified':
        return Colors.green.shade700;
      default:
        return Colors.black87;
    }
  }
}
