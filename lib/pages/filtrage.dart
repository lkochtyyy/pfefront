import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function({
    required String brand,
    required String condition,
    required String rating,
    required String sort,
    required RangeValues priceRange,
  }) onApply;

  const FilterBottomSheet({super.key, required this.onApply});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(80000, 200000);
  String _selectedSort = "Most Recent";
  String _selectedRating = "All";
  String _selectedBrand = "All";
  String _selectedCondition = "All";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedBrand = prefs.getString('selectedBrand') ?? "All";
      _selectedCondition = prefs.getString('selectedCondition') ?? "All";
      _selectedRating = prefs.getString('selectedRating') ?? "All";
      _selectedSort = prefs.getString('selectedSort') ?? "Most Recent";
      _priceRange = RangeValues(
        prefs.getDouble('priceStart') ?? 80000,
        prefs.getDouble('priceEnd') ?? 200000,
      );
    });
  }

  Future<void> _saveFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedBrand', _selectedBrand);
    prefs.setString('selectedCondition', _selectedCondition);
    prefs.setString('selectedRating', _selectedRating);
    prefs.setString('selectedSort', _selectedSort);
    prefs.setDouble('priceStart', _priceRange.start);
    prefs.setDouble('priceEnd', _priceRange.end);
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(80000, 200000);
      _selectedSort = "Most Recent";
      _selectedRating = "All";
      _selectedBrand = "All";
      _selectedCondition = "All";
    });
    _saveFilters();
  }

  Future<void> _applyFilters() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text("Filters Applied!", style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    Navigator.pop(context);

    widget.onApply(
      brand: _selectedBrand,
      condition: _selectedCondition,
      rating: _selectedRating,
      sort: _selectedSort,
      priceRange: _priceRange,
    );
    _saveFilters();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 48 : 20,
        vertical: 16,
      ),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 30.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(height: 12),
                Text("Sort & Filter",
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildFilterSectionWithIcon(
                  icon: Icons.car_rental,
                  title: "Car Brands",
                  options: const [
                    "All",
                    "Mercedes",
                    "Tesla",
                    "BMW",
                    "Audi",
                    "Toyota",
                    "Ford"
                  ],
                  selected: _selectedBrand,
                  onChanged: (val) => setState(() => _selectedBrand = val),
                ),
                _buildFilterSectionWithIcon(
                  icon: Icons.build,
                  title: "Car Condition",
                  options: const ["All", "New", "Used"],
                  selected: _selectedCondition,
                  onChanged: (val) => setState(() => _selectedCondition = val),
                ),
                _buildPriceSlider(),
                _buildFilterSectionWithIcon(
                  icon: Icons.sort,
                  title: "Sort by",
                  options: const [
                    "Popular",
                    "Most Recent",
                    "Price High",
                    "Price Low"
                  ],
                  selected: _selectedSort,
                  onChanged: (val) => setState(() => _selectedSort = val),
                ),
                _buildFilterSectionWithIcon(
                  icon: Icons.star_rate,
                  title: "Rating",
                  options: const ["All", "5", "4", "3", "2"],
                  selected: _selectedRating,
                  onChanged: (val) => setState(() => _selectedRating = val),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _resetFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text("Reset", style: GoogleFonts.poppins()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ))
                              : Text("Apply",
                                  key: const ValueKey("apply_text"),
                                  style: GoogleFonts.poppins()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Price Range",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        RangeSlider(
          values: _priceRange,
          min: 20000,
          max: 300000,
          divisions: 100,
          activeColor: const Color.fromARGB(255, 105, 58, 194),
          inactiveColor: Colors.grey.shade300,
          labels: RangeLabels(
            "\$${_priceRange.start.toInt()}",
            "\$${_priceRange.end.toInt()}",
          ),
          onChanged: (values) {
            setState(() => _priceRange = values);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("\$${_priceRange.start.toInt()}",
                style: GoogleFonts.poppins()),
            Text("\$${_priceRange.end.toInt()}", style: GoogleFonts.poppins()),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilterSectionWithIcon({
    required IconData icon,
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87), // Utilisation correcte
            const SizedBox(width: 6),
            Text(title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((label) {
              final isSelected = selected == label;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => onChanged(label),
                  backgroundColor: Colors.white,
                  selectedColor: Colors.black,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
