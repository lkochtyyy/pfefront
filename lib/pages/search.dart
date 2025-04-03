import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchCarsPage(),
    );
  }
}

class SearchCarsPage extends StatefulWidget {
  const SearchCarsPage({super.key});

  @override
  _SearchCarsPageState createState() => _SearchCarsPageState();
}

class _SearchCarsPageState extends State<SearchCarsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedYear;
  String? _selectedFuel;
  String? _selectedLocation;
  String? _selectedPrice;

  final List<String> carBrands = [
    "Toyota",
    "Peugeot",
    "Renault",
    "Mercedes",
    "BMW",
    "Audi",
    "Ford",
    "Fiat",
    "Hyundai",
    "Volkswagen"
  ];

  final Map<String, List<String>> carModels = {
    "Toyota": [
      "Corolla",
      "Yaris",
      "Camry",
      "RAV4",
      "Hilux",
      "Land Cruiser",
      "Prius",
      "C-HR",
      "Avensis",
      "Auris"
    ],
    "Peugeot": [
      "208",
      "308",
      "3008",
      "5008",
      "2008",
      "406",
      "407",
      "508",
      "RCZ",
      "Partner"
    ],
    "Renault": [
      "Clio",
      "Megane",
      "Scenic",
      "Talisman",
      "Kadjar",
      "Captur",
      "Fluence",
      "Koleos",
      "Laguna",
      "Symbol"
    ],
    "Mercedes": [
      "A-Class",
      "C-Class",
      "E-Class",
      "S-Class",
      "GLA",
      "GLC",
      "GLE",
      "GLS",
      "Vito",
      "Sprinter"
    ],
    "BMW": [
      "Serie 1",
      "Serie 2",
      "Serie 3",
      "Serie 4",
      "Serie 5",
      "Serie 6",
      "Serie 7",
      "X1",
      "X3",
      "X5"
    ],
    "Audi": ["A1", "A3", "A4", "A5", "A6", "A7", "A8", "Q2", "Q5", "Q7"],
    "Ford": [
      "Fiesta",
      "Focus",
      "Mondeo",
      "Kuga",
      "Edge",
      "Puma",
      "Galaxy",
      "S-Max",
      "Mustang",
      "Ranger"
    ],
    "Fiat": [
      "500",
      "Panda",
      "Tipo",
      "Punto",
      "Bravo",
      "Doblo",
      "Fiorino",
      "Scudo",
      "Freemont",
      "Ducato"
    ],
    "Hyundai": [
      "i10",
      "i20",
      "i30",
      "Tucson",
      "Santa Fe",
      "Kona",
      "Elantra",
      "Accent",
      "Sonata",
      "H1"
    ],
    "Volkswagen": [
      "Golf",
      "Polo",
      "Passat",
      "Tiguan",
      "Touareg",
      "Touran",
      "Arteon",
      "T-Roc",
      "ID.3",
      "ID.4"
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5F6FA),
      appBar: AppBar(
        title: const Text('Chercher une voiture',
            style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFD5F6FA),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Chercher...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onTap: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
            if (_showFilters) ...[
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                hint: const Text("Sélectionnez une marque"),
                items: carBrands
                    .map((brand) =>
                        DropdownMenuItem(value: brand, child: Text(brand)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                    _selectedModel = null;
                  });
                },
              ),
              if (_selectedBrand != null) ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedModel,
                  hint: const Text("Sélectionnez un modèle"),
                  items: carModels[_selectedBrand]!
                      .map((model) =>
                          DropdownMenuItem(value: model, child: Text(model)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedModel = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Année",
                  prefixIcon: Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Type de carburant",
                  prefixIcon: Icon(Icons.local_gas_station),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Localisation",
                  prefixIcon: Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Prix",
                  prefixIcon: Icon(Icons.attach_money),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
