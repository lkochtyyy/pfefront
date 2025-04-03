import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PublierAnnoncePage extends StatefulWidget {
  const PublierAnnoncePage({super.key});

  @override
  _PublierAnnoncePageState createState() => _PublierAnnoncePageState();
}

class _PublierAnnoncePageState extends State<PublierAnnoncePage> {
  final List<String> marquesModeles = [
    'BMW - Série 3',
    'BMW - X5',
    'Audi - A4',
    'Audi - Q7',
    'Mercedes - Classe C',
    'Mercedes - GLE',
    'Toyota - Corolla',
    'Toyota - Yaris',
    'Honda - Civic',
    'Honda - CR-V'
  ];

  final List<String> carburants = [
    'Essence',
    'Diesel',
    'Électrique',
    'Hybride'
  ];
  final List<String> annees =
      List.generate(24, (index) => (2001 + index).toString());
  final List<String> localisations = [
    'Tunis',
    'Sfax',
    'Sousse',
    'Nabeul',
    'Bizerte',
    'Gabès',
    'Kairouan',
    'Gafsa',
    'Monastir',
    'Tozeur'
  ];

  String? selectedMarqueModele;
  String? selectedCarburant;
  String? selectedAnnee;
  String? selectedLocalisation;
  TextEditingController prixController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController customInputController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    prixController.dispose();
    descriptionController.dispose();
    customInputController.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        onChanged(value);
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int? maxLines}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1F2F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Publier Une Annonce",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
                    ? const Center(
                        child: Icon(Icons.add, color: Colors.blue, size: 40),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildDropdownField(
                "Marque & Modèle ", selectedMarqueModele, marquesModeles,
                (value) {
              setState(() => selectedMarqueModele = value);
            }),
            const SizedBox(height: 10),
            _buildDropdownField("Année 📅 ", selectedAnnee, annees, (value) {
              setState(() => selectedAnnee = value);
            }),
            const SizedBox(height: 10),
            _buildDropdownField(
                "Type de carburant ⛽ ", selectedCarburant, carburants, (value) {
              setState(() => selectedCarburant = value);
            }),
            const SizedBox(height: 10),
            _buildDropdownField(
                "Localisation 📍 ", selectedLocalisation, localisations,
                (value) {
              setState(() => selectedLocalisation = value);
            }),
            const SizedBox(height: 10),
            _buildTextField("Prix 💰", prixController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            const Text("Description :",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            // Le container autour du champ de texte de description n'a plus de BoxDecoration
            _buildTextField(
              "Décrivez plus votre voiture...",
              descriptionController,
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Action de publication
                  if (prixController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      selectedMarqueModele == null ||
                      selectedAnnee == null ||
                      selectedCarburant == null ||
                      selectedLocalisation == null) {
                    // Affiche un message d'erreur si un champ est vide
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Veuillez remplir tous les champs')),
                    );
                  } else {
                    // Logic to publish the ad
                  }
                },
                child: const Text(
                  "Publier maintenant",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
