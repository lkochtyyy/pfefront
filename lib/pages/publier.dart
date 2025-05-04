import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pfefront/blocs/announcement/car_announcement_bloc.dart';
import 'package:pfefront/data/models/announcement_model.dart';
import 'package:pfefront/pages/mypubs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublierAnnoncePage extends StatefulWidget {
  final Map<String, dynamic>? publicationData;

  const PublierAnnoncePage({super.key, this.publicationData});

  @override
  State<PublierAnnoncePage> createState() => _PublierAnnoncePageState();
}

class _PublierAnnoncePageState extends State<PublierAnnoncePage>
    with SingleTickerProviderStateMixin {
  // Contrôleurs
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _titreController = TextEditingController();
  final _anneeController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _kilometrageController = TextEditingController();
  final _lieuController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();

  // États
  int _currentPage = 0;
  bool _isLoading = false;
  String _condition = 'Nouveau';
  String _carburant = 'Essence';
  String _boite = 'Automatique';
  bool _bluetooth = false, _alarm = false, _cruise = false, _parking = false;
  List<bool> _completedSections = [false, false, false];
  bool _isDescriptionFocused = false;

  // Animations
  late AnimationController _bgController;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  // Images
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // Constantes de style
  final Color _primaryColor = const Color(0xFF50C2C9);
  final Color _secondaryColor = const Color.fromARGB(255, 139, 89, 200);
  final Color _backgroundColor = const Color(0xFFE1F5F7);
  final Duration _animationDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _prefillDataIfEditing();
  }

  void _initAnimations() {
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _color1 = ColorTween(
      begin: _primaryColor,
      end: _backgroundColor,
    ).animate(_bgController);

    _color2 = ColorTween(
      begin: _backgroundColor,
      end: _primaryColor,
    ).animate(_bgController);
  }

  void _prefillDataIfEditing() {
    if (widget.publicationData != null) {
      _titreController.text = widget.publicationData!['titre'] ?? '';
      _anneeController.text = widget.publicationData!['annee'] ?? '';
      _marqueController.text = widget.publicationData!['marque'] ?? '';
      _modeleController.text = widget.publicationData!['modele'] ?? '';
      _kilometrageController.text =
          widget.publicationData!['kilometrage'] ?? '';
      _lieuController.text = widget.publicationData!['lieu'] ?? '';
      _prixController.text = widget.publicationData!['prix'] ?? '';
      _descriptionController.text =
          widget.publicationData!['description'] ?? '';
      _condition = widget.publicationData!['condition'] ?? 'Nouveau';
      _carburant = widget.publicationData!['carburant'] ?? 'Essence';
      _boite = widget.publicationData!['boite'] ?? 'Automatique';

      // Pré-remplir les options si elles existent
      if (widget.publicationData!.containsKey('options')) {
        final options = widget.publicationData!['options'] as Map<String, bool>;
        _bluetooth = options['bluetooth'] ?? false;
        _alarm = options['alarm'] ?? false;
        _cruise = options['cruise'] ?? false;
        _parking = options['parking'] ?? false;
      }

      // Marquer toutes les sections comme complétées si on est en mode édition
      _completedSections = [true, true, true];
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _pageController.dispose();
    _titreController.dispose();
    _anneeController.dispose();
    _marqueController.dispose();
    _modeleController.dispose();
    _kilometrageController.dispose();
    _lieuController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImages.clear(); // Supprime les images précédentes
          _selectedImages.add(File(image.path)); // Ajoute la nouvelle image
        });
      }
    } on PlatformException catch (e) {
      _showErrorSnackbar(
          'Erreur lors de la sélection de l\'image: ${e.message}');
    }
  }

  Future<void> _removeImage(int index) async {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _showPhoneNumberDialog() async {
    bool isSuccess = false; // État pour afficher le message de succès
    bool isLoading = false; // État pour afficher le CircularProgressIndicator
    bool showLottie = false; // État pour afficher l'animation Lottie
    String phoneError = ""; // Message d'erreur pour le champ de téléphone

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: showLottie
                      ? Column(
                          key: const ValueKey('lottie'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              'assets/json/pub.json',
                              height: 200,
                              repeat: false,
                              onLoaded: (composition) {
                                Future.delayed(const Duration(seconds: 5), () {
                                  setState(() {
                                    isSuccess =
                                        true; // Passer à l'état de succès
                                    showLottie =
                                        false; // Masquer l'animation Lottie
                                  });
                                });
                              },
                            ),
                          ],
                        )
                      : isSuccess
                          ? Column(
                              key: const ValueKey('success'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Véhicule publié avec succès !",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Bouton "Créer une autre annonce"
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          // Réinitialiser le formulaire
                                          setState(() {
                                            _titreController.clear();
                                            _anneeController.clear();
                                            _marqueController.clear();
                                            _modeleController.clear();
                                            _kilometrageController.clear();
                                            _lieuController.clear();
                                            _prixController.clear();
                                            _descriptionController.clear();
                                            _selectedImages.clear();
                                            _condition = 'Nouveau';
                                            _carburant = 'Essence';
                                            _boite = 'Automatique';
                                            _bluetooth = false;
                                            _alarm = false;
                                            _cruise = false;
                                            _parking = false;
                                            _completedSections = [
                                              false,
                                              false,
                                              false
                                            ];
                                          });

                                          // Revenir au premier bloc
                                          _pageController.animateToPage(
                                            0,
                                            duration: _animationDuration,
                                            curve: Curves.easeInOut,
                                          );

                                          // Fermer la modal
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.add,
                                            color: Colors.white),
                                        label: Text(
                                          "Créer une autre",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.grey[600], // Couleur grise
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Bouton "Voir mon annonce"
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const MyPubsPage()),
                                          );
                                        },
                                        icon: const Icon(Icons.visibility,
                                            color: Colors.white),
                                        label: Text(
                                          "Voir mon annonce",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              key: const ValueKey('form'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16),
                                ),
                                Icon(Icons.phone_android,
                                    size: 50, color: _secondaryColor),
                                const SizedBox(height: 10),
                                Text(
                                  "Ajouter votre numéro",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Veuillez saisir un numéro valide pour que les acheteurs peuvent vous contacter.",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: GoogleFonts.poppins(),
                                  decoration: InputDecoration(
                                    labelText: "Numéro de téléphone",
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Lottie.asset(
                                        'assets/json/phone.json',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    errorText: phoneError.isNotEmpty
                                        ? phoneError
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                  ),
                                  onChanged: (value) {
                                    if (phoneError.isNotEmpty) {
                                      setState(() => phoneError = '');
                                    }
                                  },
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: isLoading
                                            ? null
                                            : () => Navigator.pop(context),
                                        icon: const Icon(Icons.close,
                                            color: Colors.red),
                                        label: Text("Annuler",
                                            style: GoogleFonts.poppins(
                                                color: Colors.red)),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          side: const BorderSide(
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () async {
                                                final phone = _phoneController
                                                    .text
                                                    .trim();
                                                if (!RegExp(r'^[0-9]{8}$')
                                                    .hasMatch(phone)) {
                                                  setState(() {
                                                    phoneError =
                                                        "Numéro invalide. 8 chiffres requis.";
                                                  });
                                                  return;
                                                }

                                                setState(
                                                    () => isLoading = true);

                                                // Simuler un délai pour la validation
                                                await Future.delayed(
                                                    const Duration(seconds: 2));

                                                setState(() {
                                                  isLoading = false;
                                                  showLottie =
                                                      true; // Afficher l'animation Lottie
                                                });
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              _secondaryColor, // Couleur mauve
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.check_circle,
                                                      color: Colors.white),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Confirmer",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white),
                                                  ),
                                                ],
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
        );
      },
    );
  }

  Future<void> _showLoadingDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _publish() async {
    print("Méthode _publish appelée");

    if (!_validateCurrentPage()) return;

    if (_selectedImages.isEmpty) {
      print("Erreur : aucune image sélectionnée");
      _showErrorSnackbar('Veuillez ajouter au moins une image');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      print("Erreur : userId est null");
      _showErrorSnackbar('Erreur : utilisateur non connecté');
      return;
    }
    print("userId: $userId");

    // Convertir les options en chaîne de caractères
    final optionsString = [
      if (_bluetooth) 'bluetooth',
      if (_alarm) 'alarm',
      if (_cruise) 'cruise',
      if (_parking) 'parking',
    ].join(',');

    try {
      // Convertir les champs numériques
      final annee = int.tryParse(_anneeController.text.trim()) ?? 0;
      final kilometrage = int.tryParse(_kilometrageController.text.trim()) ?? 0;
      final prix = double.tryParse(_prixController.text.trim()) ?? 0.0;

      // Préparer les données de l'annonce
      final announcement = CarAnnouncement(
        title: _titreController.text,
        carCondition: _condition,
        year: annee,
        brand: _marqueController.text,
        model: _modeleController.text,
        fuelType: _carburant,
        mileage: kilometrage,
        options: optionsString,
        location: _lieuController.text,
        price: prix,
        description: _descriptionController.text,
        imageFile: _selectedImages.first,
        imageUrl: '',
        vendorId: int.parse(userId),
      );

      print("Données de l'annonce : $announcement");

      // Ajouter l'événement au BLoC
      print("Ajout de l'événement CreateAnnouncement au BLoC");
      context.read<CarAnnouncementBloc>().add(
            CreateAnnouncement(
              userId: userId,
              announcement: announcement,
              imageFile: _selectedImages.first,
            ),
          );
    } catch (e) {
      print("Erreur lors de l'ajout de l'événement au BLoC : $e");
      _showErrorSnackbar('Une erreur est survenue lors de la publication.');
    }
  }

  bool _validateCurrentPage() {
    bool isValid = false;

    switch (_currentPage) {
      case 0:
        isValid = _validateFields([
          _titreController,
          _anneeController,
          _marqueController,
          _modeleController
        ]);
        break;
      case 1:
        isValid = _validateFields([_kilometrageController]);
        break;
      case 2:
        isValid = _validateFields([_lieuController, _prixController]);
        break;
    }
    print("Validation de la page $_currentPage : $isValid");
    if (isValid) {
      setState(() {
        _completedSections[_currentPage] = true;
        if (_currentPage < 2) {
          Future.delayed(_animationDuration, () {
            _pageController.nextPage(
              duration: _animationDuration,
              curve: Curves.easeInOut,
            );
          });
        }
      });
    }

    return isValid;
  }

  bool _validateFields(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      if (controller.text.trim().isEmpty) {
        _showErrorSnackbar('Veuillez remplir tous les champs obligatoires');
        return false;
      }
    }
    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarAnnouncementBloc, CarAnnouncementState>(
      listener: (context, state) {
        if (state is CarAnnouncementLoading) {
          setState(() => _isLoading = true);
        } else if (state is AnnouncementCreated) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Annonce publiée avec succès !')),
          );
          Navigator.pop(context); // Retour à la page précédente
        } else if (state is CarAnnouncementError) {
          setState(() => _isLoading = false);
          _showErrorSnackbar(state.error);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            widget.publicationData != null
                ? "Modifier l'annonce"
                : "Publier une annonce",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [
            if (widget.publicationData != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmationDialog(),
              ),
          ],
        ),
        body: AnimatedBuilder(
          animation: _bgController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color1.value!, _color2.value!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildPageIndicator(),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                              print("Page actuelle : $_currentPage");
                            });
                          },
                          children: [
                            _buildInfoSection(),
                            _buildFeaturesSection(),
                            _buildDetailsSection(),
                          ],
                        ),
                      ),
                      if (_currentPage == 2) _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirmer la suppression",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          "Êtes-vous sûr de vouloir supprimer cette annonce ? Cette action est irréversible.",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Annuler",
              style: GoogleFonts.poppins(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter la suppression
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Annonce supprimée avec succès')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              "Supprimer",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () {
              if (index == 0 || _completedSections[index - 1]) {
                _pageController.animateToPage(
                  index,
                  duration: _animationDuration,
                  curve: Curves.easeInOut,
                );
              }
            },
            child: AnimatedContainer(
              duration: _animationDuration,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: _currentPage == index ? 24 : 12,
              height: 12,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? _primaryColor
                    : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color:
                      _completedSections[index] ? Colors.green : _primaryColor,
                  width: 2,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOutQuart,
      switchOutCurve: Curves.easeInQuart,
      child: _currentPage == 2
          ? Padding(
              key: const ValueKey("submit_button"),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: GestureDetector(
                onTapDown: (_) => HapticFeedback.lightImpact(),
                onTap: _isLoading ? null : _publish,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: _isLoading
                          ? [
                              _secondaryColor.withOpacity(0.6),
                              _primaryColor.withOpacity(0.6)
                            ]
                          : [_secondaryColor, _primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.publish, color: Colors.white),
                                const SizedBox(width: 12),
                                Text(
                                  widget.publicationData != null
                                      ? "Mettre à jour l'annonce"
                                      : "Publier ma voiture",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(key: ValueKey("empty"), height: 24),
    );
  }

  Widget _buildInfoSection() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Lottie.asset(
                  'assets/json/decor.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 400),
                  child: _buildCard(
                    title: "Titre de l'annonce",
                    children: [
                      const SizedBox(height: 20),
                      _buildStyledTextField(
                        "Titre de l'annonce*",
                        _titreController,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Ce champ est obligatoire'
                            : null,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Commencez par indiquer un titre clair et descriptif qui attirera l'attention des acheteurs.",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end, // Aligner à droite
                        children: [
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_titreController.text.trim().isEmpty) {
                                  _showErrorSnackbar(
                                      'Veuillez remplir le titre de l\'annonce');
                                } else {
                                  _pageController.animateToPage(
                                    1,
                                    duration: _animationDuration,
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _secondaryColor,
                                padding: const EdgeInsets.all(16),
                                shape: const CircleBorder(),
                                shadowColor: _secondaryColor.withOpacity(0.5),
                                elevation: 8,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard(
            title: "Détails Techniques",
            children: [
              const SizedBox(height: 20),
              _buildAnimatedFormRow([
                _buildLottieField(
                  animationPath: 'assets/json/year.json',
                  label: "Année*",
                  controller: _anneeController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Ce champ est obligatoire';
                    final year = int.tryParse(value!);
                    if (year == null ||
                        year < 1900 ||
                        year > DateTime.now().year + 1) {
                      return 'Année invalide';
                    }
                    return null;
                  },
                ),
                _buildLottieField(
                  animationPath: 'assets/json/kilo.json',
                  label: "Kilométrage*",
                  controller: _kilometrageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Ce champ est obligatoire';
                    final km = int.tryParse(value!);
                    if (km == null || km < 0) return 'Valeur invalide';
                    return null;
                  },
                ),
              ]),
              const SizedBox(height: 20),
              _buildAnimatedFormRow([
                _buildLottieField(
                  animationPath: 'assets/json/mark.json',
                  label: "Marque*",
                  controller: _marqueController,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Ce champ est obligatoire'
                      : null,
                ),
                _buildLottieField(
                  animationPath: 'assets/json/model.json',
                  label: "Modèle*",
                  controller: _modeleController,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Ce champ est obligatoire'
                      : null,
                ),
              ]),
              const SizedBox(height: 30),
              _buildDivider(),
              // Carburant au-dessus de Boîte de vitesse
              _buildLottieDropdown(
                animationPath: 'assets/json/fuuel.json',
                label: "Carburant*",
                value: _carburant,
                items: const ["Essence", "Diesel", "Hybride", "Électrique"],
                onChanged: (val) => setState(() => _carburant = val!),
              ),
              const SizedBox(height: 20),
              _buildLottieDropdown(
                animationPath: 'assets/json/gearbox.json',
                label: "Boîte de vitesse*",
                value: _boite,
                items: const ["Automatique", "Manuelle"],
                onChanged: (val) => setState(() => _boite = val!),
              ),
              const SizedBox(height: 20),

              _buildLottieDropdown(
                animationPath:
                    'assets/json/carinfo.json', // Remplacez par une animation appropriée si disponible
                label: "Condition*",
                value: _condition,
                items: const ["Nouveau", "Ancien"],
                onChanged: (val) => setState(() => _condition = val!),
              ),
              const SizedBox(height: 20),

              _buildDivider(),
              _buildOptionsExpansionTile(),

              const SizedBox(height: 20),
              _buildNavigationButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard(
            title: "Finalisation",
            children: [
              const SizedBox(height: 20),
              _buildAnimatedFormRow([
                _buildLottieField(
                  animationPath: 'assets/json/place.json',
                  label: "Lieu*",
                  controller: _lieuController,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Ce champ est obligatoire'
                      : null,
                ),
                _buildLottieField(
                  animationPath: 'assets/json/price.json',
                  label: "Prix* (FCFA)",
                  controller: _prixController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Ce champ est obligatoire';
                    final price = double.tryParse(value!);
                    if (price == null || price <= 0) return 'Prix invalide';
                    return null;
                  },
                ),
              ]),
              const SizedBox(height: 20),
              _buildDivider(),
              _buildDescriptionField(),
              const SizedBox(height: 20),
              _buildDivider(),
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildNavigationButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bouton Retour
        FadeInLeft(
          delay: const Duration(milliseconds: 300),
          child: ElevatedButton(
            onPressed: () {
              _pageController.previousPage(
                duration: _animationDuration,
                curve: Curves.easeInOut,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300], // Couleur grise
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
              shadowColor: Colors.grey.withOpacity(0.5),
              elevation: 8,
            ),
            child: const Icon(
              Icons.arrow_back, // Flèche inversée
              color: Colors.black87,
              size: 24,
            ),
          ),
        ),

        // Bouton Suivant
        if (_currentPage < 2)
          FadeInRight(
            delay: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: () {
                if (_validateCurrentPage()) {
                  _pageController.nextPage(
                    duration: _animationDuration,
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _secondaryColor, // Couleur mauve
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
                shadowColor: _secondaryColor.withOpacity(0.5),
                elevation: 8,
              ),
              child: const Icon(
                Icons.arrow_forward, // Flèche vers l'avant
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedFormRow(List<Widget> children) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: children[i]),
        ],
      ],
    );
  }

  Widget _buildLottieField({
    required String animationPath,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Lottie.asset(animationPath),
        ),
        const SizedBox(height: 8),
        _buildStyledTextField(
          label,
          controller,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildLottieDropdown({
    required String animationPath,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Lottie.asset(animationPath),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
          ),
          style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors
                  .black87), // Police Poppins pour les éléments sélectionnés
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors
                              .black87), // Police Poppins pour les options
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 30,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildOptionsExpansionTile() {
    return ExpansionTile(
      initiallyExpanded: widget.publicationData != null,
      title: Text(
        "Options",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      children: [
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4,
          children: [
            _buildCheckbox("Alarme", _alarm,
                (val) => setState(() => _alarm = val ?? false)),
            _buildCheckbox("Bluetooth", _bluetooth,
                (val) => setState(() => _bluetooth = val ?? false)),
            _buildCheckbox("Régulateur de vitesse", _cruise,
                (val) => setState(() => _cruise = val ?? false)),
            _buildCheckbox("Capteur de stationnement", _parking,
                (val) => setState(() => _parking = val ?? false)),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _isDescriptionFocused = hasFocus;
                });
              },
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                style: GoogleFonts.poppins(
                  // Appliquer la police Poppins au texte saisi
                  fontSize: 14,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Décrivez votre véhicule en détail...",
                  hintStyle: GoogleFonts.poppins(
                    // Appliquer la police Poppins au texte d'indice
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _primaryColor, width: 2),
                  ),
                ),
              ),
            ),
            if (!_isDescriptionFocused)
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Lottie.asset('assets/json/description.json'),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Décrivez l'état général, les options, l'historique et toute information utile pour les acheteurs.",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Photo du véhicule*",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Ajoutez une photo de bonne qualité",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.5,
                style: BorderStyle.solid,
              ),
            ),
            child: _selectedImages.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/json/add.json',
                        height: 80,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Cliquez pour ajouter une photo",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImages.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImages.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required List<Widget> children,
    String? title,
    String? lottieAsset,
  }) {
    return FadeIn(
      duration: _animationDuration,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lottieAsset != null) ...[
              Center(
                child: SizedBox(
                    height: 100,
                    child: Lottie.asset(lottieAsset, fit: BoxFit.contain)),
              ),
            ],
            const SizedBox(height: 10),
            if (title != null) ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 80,
                      decoration: BoxDecoration(
                        color:
                            _secondaryColor, // Utilisation de la couleur mauve
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.grey,
      ),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: _primaryColor,
        dense: true,
      ),
    );
  }
}
