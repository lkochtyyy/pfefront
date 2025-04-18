import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfefront/pages/favoris.dart';
import 'package:pfefront/pages/messagerie.dart';
import 'package:pfefront/pages/editprofile.dart';
import 'package:pfefront/pages/publier.dart';
import 'package:pfefront/pages/search.dart';
import 'package:pfefront/pages/filtrage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FeaturedCarsPage extends StatefulWidget {
  final String userId;
  const FeaturedCarsPage({super.key, required this.userId});

  @override
  State<FeaturedCarsPage> createState() => _FeaturedCarsPageState();
}

class _FeaturedCarsPageState extends State<FeaturedCarsPage> {
  List<Map<String, dynamic>> cars = [
    {
      'title': 'BMW serie 2',
      'price': 180000,
      'status': 'NOUVEAU',
      'color': Colors.blueGrey[200],
      'image': 'assets/bmw s2.png'
    },
    {
      'title': 'C63 AMG',
      'price': 200000,
      'status': 'Ancien',
      'color': Colors.blueGrey[200],
      'image': 'assets/C63 AMG.png'
    },
    {
      'title': 'Audi RS7',
      'price': 250000,
      'status': 'NOUVEAU',
      'color': Colors.blueGrey[200],
      'image': 'assets/Audi RS7.png'
    },
    {
      'title': 'Mercedes G63',
      'price': 300000,
      'status': 'Ancien',
      'color': Colors.blueGrey[200],
      'image': 'assets/Mercedes G63.png'
    },
    {
      'title': 'Porsche 911',
      'price': 400000,
      'status': 'Ancien',
      'color': Colors.blueGrey[200],
      'image': 'assets/Porsche 911.png'
    },
  ];

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() => _searchText = result.recognizedWords);
      });
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterBottomSheet(
          onApply: ({
            required String brand,
            required String condition,
            required RangeValues priceRange,
            required String rating,
            required String sort,
          }) {
            print(
                "Brand: $brand, Condition: $condition, Rating: $rating, Sort: $sort, Price Range: $priceRange");
          },
        );
      },
    );
  }

  void sortCars() {
    setState(() {
      cars.sort((a, b) => isAscending
          ? a['price'].compareTo(b['price'])
          : b['price'].compareTo(a['price']));
      isAscending = !isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedCars = cars;

    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                const SizedBox(height: 20),
                _buildSearchField(context),
                const SizedBox(height: 20),
                _buildFeaturedSection(),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: displayedCars.length,
                      itemBuilder: (context, index) {
                        return CarCard(car: displayedCars[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: const Duration(seconds: 10),
      curve: Curves.easeInOut,
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
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'CARZone',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: const Color.fromARGB(255, 9, 5, 5),
          fontSize: 24,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {
            print("More options");
          },
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).push(_createSearchRoute());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.2,
            ),
          ),
          child: IgnorePointer(
            child: TextField(
              enabled: false,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search any Product..',
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Featured Cars',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.filter_alt_outlined, size: 18),
            label: Text(
              "Filter",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
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
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Publish',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email_rounded),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars_rounded),
          label: 'Favorites',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PublierAnnoncePage()),
            );
            break;

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatsPage()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavorisPage()),
            );
            break;
        }
      },
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
                  child: Icon(Icons.star, color: Colors.black54),
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

Route _createSearchRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SearchCarsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffset = Offset(0.0, 1.0); // from bottom
      const endOffset = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: beginOffset, end: endOffset)
          .chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}
