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
  bool _hasResults = false;
  bool _showFilters = false;

  String? _selectedBrand;
  String? _selectedModel;
  RangeValues _priceRange = const RangeValues(10000, 50000);

  final List<String> carBrands = ['BMW', 'Audi', 'Mercedes'];
  final Map<String, List<String>> carModels = {
    'BMW': ['X1', 'X3', 'X5'],
    'Audi': ['A3', 'A4', 'Q5'],
    'Mercedes': ['C-Class', 'E-Class', 'GLA'],
  };

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  void _triggerSearch() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
      _hasResults = true;
    });

    _showBottomSheet();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Résultats",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _hasResults
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (_, index) {
                        return ListTile(
                          leading: const Icon(Icons.directions_car),
                          title: Text("Voiture ${index + 1}",
                              style: GoogleFonts.poppins()),
                          subtitle: Text("Description ici",
                              style: GoogleFonts.poppins(fontSize: 12)),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Aucun résultat trouvé",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
            ],
          ),
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
          colors: [
            Color(0xFF50C2C9),
            Color(0xFFE1F5F7),
            Color(0xFFEAEAEA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF50C2C9),
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: Colors.black54, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    cursorColor: const Color(0xFF50C2C9),
                    cursorWidth: 2.5,
                    cursorRadius: const Radius.circular(8),
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: "Search filters...",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.black54),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black45),
                        onPressed: () => _searchController.clear(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .slideY(begin: -0.3, duration: 500.ms)
              .fadeIn(duration: 500.ms),
        ),
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/search.json', height: 250),
                      const SizedBox(height: 20),
                      Text(
                        "Recherche en cours...",
                        style: GoogleFonts.poppins(fontSize: 16),
                      )
                    ],
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _showFilters = !_showFilters);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF50C2C9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _showFilters
                              ? "Masquer les filtres"
                              : "Afficher les filtres",
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Filtrer par :",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: _selectedBrand,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Sélectionner une marque",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              style: GoogleFonts.poppins(color: Colors.black),
                              items: carBrands
                                  .map((brand) => DropdownMenuItem(
                                        value: brand,
                                        child: Text(brand,
                                            style: GoogleFonts.poppins()),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedBrand = val;
                                  _selectedModel = null;
                                });
                              },
                            ).animate().fadeIn().slideY(begin: 0.2),
                            const SizedBox(height: 10),
                            if (_selectedBrand != null)
                              DropdownButtonFormField<String>(
                                value: _selectedModel,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Modèle",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                style: GoogleFonts.poppins(color: Colors.black),
                                items: carModels[_selectedBrand]!
                                    .map((model) => DropdownMenuItem(
                                          value: model,
                                          child: Text(model,
                                              style: GoogleFonts.poppins()),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() => _selectedModel = val);
                                },
                              ).animate().fadeIn().slideY(begin: 0.2),
                            const SizedBox(height: 10),
                            Text(
                              "Prix : \$${_priceRange.start.round()} - \$${_priceRange.end.round()}",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            RangeSlider(
                              values: _priceRange,
                              min: 0,
                              max: 100000,
                              divisions: 20,
                              activeColor: const Color(0xFF50C2C9),
                              labels: RangeLabels(
                                '\$${_priceRange.start.round()}',
                                '\$${_priceRange.end.round()}',
                              ),
                              onChanged: (values) {
                                setState(() => _priceRange = values);
                              },
                            ).animate().fadeIn().slideY(begin: 0.2),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: _triggerSearch,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF50C2C9),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.search),
                                label: Text("Rechercher",
                                    style: GoogleFonts.poppins()),
                              ).animate().scale(duration: 400.ms),
                            ),
                          ],
                        ),
                        crossFadeState: _showFilters
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 400),
                      ).animate().fadeIn(duration: 500.ms),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
