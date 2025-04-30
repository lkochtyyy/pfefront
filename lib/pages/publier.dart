import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/blocs/announcement/car_announcement_bloc.dart';
import 'package:pfefront/data/models/announcement_model.dart';
import 'package:pfefront/utils/shared_prefs_helper.dart';

// If the Announcement class is not defined in the imported file, define it here or ensure the correct file is imported.

class PublierAnnoncePage extends StatefulWidget {
final Map<String, dynamic>? publicationData; // Données de la publication


  const PublierAnnoncePage({super.key, this.publicationData});

  @override
  State<PublierAnnoncePage> createState() => _CreateEditCarPageState();
}

class _CreateEditCarPageState extends State<PublierAnnoncePage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCondition = 'Nouveau'; // Valeur par défaut
  String? selectedBrand;
  String? selectedModel;
  String? selectedFuel;
  String? selectedTransmission;
  List<String> selectedFeatures = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _kilometersController = TextEditingController();

  List<String> allFeatures = [
    'Alarm',
    'Bluetooth',
    'Cruise Control',
    'Front Parking Sensor'
  ];
  List<String> fuelTypes = ['Essence', 'Diesel', 'Électrique', 'Hybride'];
  List<String> transmissions = ['Manuelle', 'Automatique'];

  File? selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 10,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final XFile? picked =
                    await picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  setState(() {
                    selectedImage = File(picked.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir depuis la galerie'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (selectedBrand == null ||
          selectedModel == null ||
          selectedFuel == null ||
          selectedTransmission == null ||
          selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires.')),
        );
        return;
      }

      try {
        final year = int.parse(_yearController.text);
        final mileage = int.parse(_kilometersController.text);
        final price = double.parse(_priceController.text);
        final String optionsString = selectedFeatures.join(',');
        final userId = await SharedPrefsHelper.getUserId();


        // Créer l'objet CarAnnouncement avec les données du formulaire
        final announcement = CarAnnouncement(
          title: _titleController.text,
          carCondition: selectedCondition!,
          year: year,
          brand: selectedBrand!,
          model: selectedModel!,
          fuelType: selectedFuel!,
          mileage: mileage,
          options: optionsString,
          location: _locationController.text,
          price: price,
          description: _descriptionController.text,
          imageFile: selectedImage!,
          imageUrl: '', // Provide a valid URL or placeholder string
          vendorId: int.parse(userId!) ,
        );

        // Envoyer l'événement au Bloc
        context.read<CarAnnouncementBloc>().add(
              CreateAnnouncement(
                announcement: announcement, imageFile: selectedImage!, userId : userId,
              ),
            );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez entrer des valeurs valides.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarAnnouncementBloc, CarAnnouncementState>(
      listener: (context, state) {
        if (state is AnnouncementCreated) {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            builder: (_) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/json/pub.json', height: 120),
                  const SizedBox(height: 12),
                  Text(
                    'Voiture ajoutée avec succès !',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context); // Fermer le bottom sheet
            Navigator.pop(context); // Revenir à l'écran précédent
          });
        }
      },
      child: Scaffold(
        body: Container(
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
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Créer / Modifier Voiture',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      'Titre',
                      _titleController,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRadioGroup(
                              'Condition', ['Nouveau', 'Ancienne']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('Année', _yearController,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              type: TextInputType.number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                              'Marque',
                              ['BMW', 'Mercedes', 'Audi'],
                              (val) => selectedBrand = val),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdown(
                              'Modèle',
                              ['Série 3', 'A4', 'Classe C'],
                              (val) => selectedModel = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown('Carburant', fuelTypes,
                              (val) => selectedFuel = val),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdown('Boîte', transmissions,
                              (val) => selectedTransmission = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Kilométrage', _kilometersController,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        type: TextInputType.number),
                    const SizedBox(height: 12),
                    Text(
                      'Options',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: allFeatures
                          .map(
                            (feature) => FilterChip(
                              label: Text(feature),
                              selected: selectedFeatures.contains(feature),
                              onSelected: (isSelected) {
  setState(() {
    isSelected
        ? selectedFeatures.add(feature)
        : selectedFeatures.remove(feature);
  });
},

                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Lieu',
                            _locationController,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('Prix', _priceController,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              type: TextInputType.number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Description', _descriptionController,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        maxLines: 4),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Center(
                        child: selectedImage == null
                            ? Column(
                                children: [
                                  Lottie.asset('assets/json/add.json',
                                      height: 180),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Cliquez ici pour ajouter une image',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.file(
                                  selectedImage!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: BlocBuilder<CarAnnouncementBloc, CarAnnouncementState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is CarAnnouncementLoading
                                ? null
                                : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C2CB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              elevation: 8,
                            ),
                            child: state is CarAnnouncementLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    'Publier ma voiture',
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType type = TextInputType.text,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: boxShadow ?? [],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Champ requis' : null,
      ),
    );
  }

  Widget _buildRadioGroup(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(
          children: options
              .map(
                (opt) => Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: opt,
                        groupValue: selectedCondition,
                        onChanged: (val) =>
                            setState(() => selectedCondition = val),
                      ),
                      Flexible(
                          child: Text(opt,
                              style: GoogleFonts.poppins(fontSize: 14),
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String hint, List<String> items, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map((item) =>
              DropdownMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Ce champ est requis' : null,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _kilometersController.dispose();
    super.dispose();
  }
}