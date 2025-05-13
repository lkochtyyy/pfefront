import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SearchCarsPage extends StatefulWidget {
  const SearchCarsPage({super.key});

  @override
  State<SearchCarsPage> createState() => _SearchCarsPageState();
}

class _SearchCarsPageState extends State<SearchCarsPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  final bool _isListening = false;
  bool _showFilters = false;
  bool _isSearching = true; // Ajouter la variable de recherche

  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedFuel;
  String? _selectedTransmission;
  RangeValues _priceRange = const RangeValues(10000, 50000);

  final List<String> carBrands = ['BMW', 'Audi', 'Mercedes'];
  final Map<String, List<String>> carModels = {
    'BMW': ['X1', 'X3', 'X5'],
    'Audi': ['A3', 'A4', 'Q5'],
    'Mercedes': ['C-Class', 'E-Class', 'GLA'],
  };
  final List<String> fuelTypes = ['Essence', 'Diesel', 'Électrique'];
  final List<String> transmissions = ['Automatique', 'Manuelle'];

  List<Map<String, String>> mockResults = [
    {
      'title': 'BMW X3',
      'price': '\$38,000',
      'info': '2022 • Essence • Automatique',
      'image':
          'https://cdn.pixabay.com/photo/2016/11/29/02/31/bmw-1868726_960_720.jpg',
    },
    {
      'title': 'Audi Q5',
      'price': '\$42,500',
      'info': '2023 • Diesel • Manuelle',
      'image':
          'https://cdn.pixabay.com/photo/2018/03/10/18/10/audi-3214461_960_720.jpg',
    },
    {
      'title': 'Mercedes GLA',
      'price': '\$46,000',
      'info': '2021 • Électrique • Automatique',
      'image':
          'https://cdn.pixabay.com/photo/2020/04/25/17/38/mercedes-5092224_960_720.jpg',
    },
  ];

  void _triggerSearch() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    _showBottomSheet();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF1F9FA), Color(0xFFE0F7F8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Text("Résultats",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: mockResults.length,
                      itemBuilder: (_, index) {
                        final result = mockResults[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                result['image']!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(result['title']!,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(result['info']!,
                                style: GoogleFonts.poppins(fontSize: 12)),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(result['price']!,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF50C2C9))),
                                const SizedBox(height: 4),
                                const Icon(Icons.favorite_border,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: const Duration(seconds: 10),
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF50C2C9), Color(0xFFE1F5F7), Color(0xFFEAEAEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
      String hint, T? value, List<T> items, void Function(T?) onChanged) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: GoogleFonts.poppins(color: Colors.black),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString(),
                    style: GoogleFonts.poppins(fontSize: 14)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildFilterSection() {
    return AnimatedContainer(
      duration: 400.ms,
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDropdown("Marque", _selectedBrand, carBrands, (val) {
                setState(() {
                  _selectedBrand = val;
                  _selectedModel = null;
                });
              }),
              const SizedBox(height: 10),
              if (_selectedBrand != null)
                _buildDropdown(
                    "Modèle", _selectedModel, carModels[_selectedBrand]!,
                    (val) {
                  setState(() => _selectedModel = val);
                }),
              const SizedBox(height: 10),
              _buildDropdown("Carburant", _selectedFuel, fuelTypes,
                  (val) => setState(() => _selectedFuel = val)),
              const SizedBox(height: 10),
              _buildDropdown(
                  "Transmission",
                  _selectedTransmission,
                  transmissions,
                  (val) => setState(() => _selectedTransmission = val)),
              const SizedBox(height: 10),
              Text(
                "Prix : \$${_priceRange.start.round()} - \$${_priceRange.end.round()}",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 100000,
                divisions: 100,
                activeColor: const Color(0xFF50C2C9),
                labels: RangeLabels(
                  '\$${_priceRange.start.round()}',
                  '\$${_priceRange.end.round()}',
                ),
                onChanged: (values) {
                  setState(() => _priceRange = values);
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _triggerSearch,
                icon: const Icon(Icons.search),
                label: Text("Rechercher", style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF50C2C9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ).animate().fadeIn().scale(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit l'AppBar animée
  Widget _buildAnimatedAppBar() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1.0,
        child: child,
      ),
      child: _isSearching ? _buildSearchField() : _buildTitleBar(),
    );
  }

  /// Construit l'AppBar avec le titre
  Widget _buildTitleBar() {
    return _buildSearchField(); // Affiche directement la barre de recherche
  }

  /// Construit l'AppBar avec le champ de recherche
  Widget _buildSearchField() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: 'Rechercher une voiture...',
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        cursorColor: Colors.black,
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildAnimatedAppBar(),
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 130, 16, 16),
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/json/search.json', height: 220),
                        const SizedBox(height: 20),
                        Text("Recherche en cours...",
                            style: GoogleFonts.poppins(fontSize: 16)),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      if (_showFilters) _buildFilterSection(),
                    ],
                  ),
          ),
          Positioned(
            top: kToolbarHeight + 16, // Position sous l'AppBar
            right: 16, // Position à droite
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters; // Affiche ou masque les filtres
                });
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showFilters
                    ? const Icon(Icons.check,
                        color: Color.fromARGB(255, 157, 57,
                            223)) // Icône de validation si les filtres sont activés
                    : const Icon(Icons.filter_list,
                        color: Color.fromARGB(
                            255, 157, 57, 223)), // Icône de filtre par défaut
              ),
              iconSize: 30, // Ajustez la taille de l'icône ici
              padding: const EdgeInsets.all(0),
            ),
          ),
        ],
      ),
    );
  }
}
