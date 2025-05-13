import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pfefront/pages/pagedacceuil.dart';

class CarBrandSelectionPage extends StatefulWidget {
  @override
  _CarBrandSelectionPageState createState() => _CarBrandSelectionPageState();
}

class _CarBrandSelectionPageState extends State<CarBrandSelectionPage> {
  final List<Map<String, String>> carBrands = [
    {'name': 'BMW', 'logo': 'assets/logos/bmw.png'},
    {'name': 'TOYOTA', 'logo': 'assets/logos/toyota.png'},
    {'name': 'OPEL', 'logo': 'assets/logos/opel.png'},
    {'name': 'AUDI', 'logo': 'assets/logos/audi.png'},
    {'name': 'ISUZU', 'logo': 'assets/logos/isuzu.png'},
    {'name': 'RENAULT', 'logo': 'assets/logos/renault.png'},
    {'name': 'MAHINDRA', 'logo': 'assets/logos/mahindra.png'},
    {'name': 'LAND ROVER', 'logo': 'assets/logos/landrover.png'},
    {'name': 'CHEVROLET', 'logo': 'assets/logos/chevrelet.png'},
    {'name': 'SUZUKI', 'logo': 'assets/logos/suzuki.png'},
    {'name': 'FIAT', 'logo': 'assets/logos/fiat.png'},
    {'name': 'FORD', 'logo': 'assets/logos/ford.png'},
    {'name': 'LAMBORGHINI', 'logo': 'assets/logos/lamborghini.png'},
    {'name': 'MORRIS GARAGE', 'logo': 'assets/logos/morris_garage.png'},
    {'name': 'HONDA', 'logo': 'assets/logos/honda.png'},
    {'name': 'HYUNDAI', 'logo': 'assets/logos/hyundai.png'},
    {'name': 'INFINITI', 'logo': 'assets/logos/infiniti.png'},
    {'name': 'JAGUAR', 'logo': 'assets/logos/jaguar.png'},
    {'name': 'PORSHE', 'logo': 'assets/logos/porshe.png'},
    {'name': 'JEEP', 'logo': 'assets/logos/jeep.png'},
    {'name': 'KIA', 'logo': 'assets/logos/kia.png'},
    {'name': 'PEUGIOT', 'logo': 'assets/logos/peugiot.png'},
    {'name': 'CITROEN', 'logo': 'assets/logos/citroen.png'},
    {'name': 'DACIA', 'logo': 'assets/logos/dacia.png'},
    {'name': 'SEAT', 'logo': 'assets/logos/seat.png'},
    {'name': 'MAZDA', 'logo': 'assets/logos/mazda.png'},
    {'name': 'MERCEDES-BENZ', 'logo': 'assets/logos/mercedes.png'},
    {'name': 'MITSUBISHI', 'logo': 'assets/logos/mitsubishi.png'},
    {'name': 'NISSAN', 'logo': 'assets/logos/nissan.png'},
    {'name': 'RAM', 'logo': 'assets/logos/ram.png'},
    {'name': 'SUBARU', 'logo': 'assets/logos/subaru.png'},
    {'name': 'TATA', 'logo': 'assets/logos/tata.png'},
    {'name': 'VOLKSWAGEN', 'logo': 'assets/logos/volkswagen.png'},
    {'name': 'VOLVO', 'logo': 'assets/logos/volvo.png'},
    {'name': 'FRRARI', 'logo': 'assets/logos/ferrari.png'},
    {'name': 'ROLLS ROYCE', 'logo': 'assets/logos/rollsroyce.png'},
    {'name': 'BENTLY', 'logo': 'assets/logos/bently.png'},
  ];

  final List<String> selectedBrands = [];
  bool _isLoading = false;
  bool _isAdding = true; // Par défaut, on suppose qu'on ajoute
  final ScrollController _scrollController = ScrollController();
  bool showAllBrands = false;

  void _onContinuePressed() async {
    // Afficher le CircularProgressIndicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandsToDisplay =
        showAllBrands ? carBrands : carBrands.take(8).toList();

    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14.0), // Ajout d'un padding horizontal
                child: Text(
                  'Sélectionnez vos marques préférées',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '${selectedBrands.length}', // Le nombre sélectionné
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isAdding
                                ? Colors.green
                                : Colors.red, // Couleur dynamique
                          ),
                        ),
                        TextSpan(
                          text:
                              ' marque${selectedBrands.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    style: GoogleFonts.poppins(),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 3 colonnes
                    mainAxisSpacing: 12, // Espacement vertical
                    crossAxisSpacing: 12, // Espacement horizontal
                    childAspectRatio:
                        1.5, // Rapport d'aspect pour une disposition 3x3
                  ),
                  itemCount: brandsToDisplay.length,
                  itemBuilder: (context, index) {
                    final brand = brandsToDisplay[index];
                    final isSelected = selectedBrands.contains(brand['name']);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedBrands.remove(brand['name']);
                            _isAdding = false; // Suppression
                          } else {
                            selectedBrands.add(brand['name']!);
                            _isAdding = true; // Ajout
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey, // Gris par défaut
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                brand['logo']!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              brand['name']!,
                              style: GoogleFonts.poppins(),
                            ),
                            if (isSelected)
                              const Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.check_circle,
                                    color: Colors.blue),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAllBrands = !showAllBrands;
                    if (!showAllBrands) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40, // Taille de la Lottie
                        width: 40,
                        child: Lottie.asset(
                          showAllBrands
                              ? 'assets/json/arrow_down.json' // Lottie pour "Afficher moins"
                              : 'assets/json/arrow_up.json', // Lottie pour "Afficher plus"
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Espacement entre la Lottie et le texte
                      Text(
                        showAllBrands ? 'Afficher moins' : 'Afficher plus',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text('Retour', style: GoogleFonts.poppins()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedBrands.isNotEmpty && !_isLoading
                            ? () async {
                                setState(() {
                                  _isLoading =
                                      true; // Activer l'état de chargement
                                });

                                // Simuler un délai (par exemple, une requête réseau)
                                await Future.delayed(
                                    const Duration(seconds: 2));

                                setState(() {
                                  _isLoading =
                                      false; // Désactiver l'état de chargement
                                });

                                // Afficher le DialogSheet
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Lottie.asset(
                                              'assets/json/thanks.json', // Animation Lottie
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Merci pour votre sélection !',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FeaturedCarsPage(), // Page d'accueil
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              'Continuer vers l\'accueil',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Confirmer',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
