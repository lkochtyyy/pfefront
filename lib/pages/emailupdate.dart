import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailUpdatePage extends StatefulWidget {
  const EmailUpdatePage({super.key});

  @override
  State<EmailUpdatePage> createState() => _EmailUpdatePageState();
}

class _EmailUpdatePageState extends State<EmailUpdatePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool isSaved = false;
  bool isPasswordVisible = false;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration:
          const Duration(seconds: 3), // Vitesse de l'animation (plus lente)
      vsync: this,
    );

    // Animation de translation verticale limitée au centre avec une distance minimale
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0), // Commence au centre
      end: const Offset(
          0, 0.1), // Réduit la distance vers le bas à 10% de l'écran
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    // Répéter l'animation (boucle infinie)
    _animationController.repeat(
        reverse: true); // reverse pour aller du bas vers le haut
  }

  // Fonction pour gérer l'enregistrement
  void handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // Animation delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        isLoading = false;
        isSaved = true;
      });

      // Custom SnackBar pour le retour d'information
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Email updated successfully'),
            ],
          ),
        ),
      );

      // Ajout d'un délai avant l'animation de succès
      await Future.delayed(const Duration(seconds: 3));

      setState(() => isSaved = false);

      Navigator.pop(context); // Retour à l'écran précédent
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Edit Email',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                // Cacher le clavier quand on tape en dehors des champs de texte
                FocusScope.of(context).unfocus();
              },
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black12,
                        offset: Offset(0, 10),
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.brown),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'If you change your email address, you may no longer be able to log in with your social login.',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Current E-Mail Address",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "hachem.barhoumi22@gmail.com",
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Confirmed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "New E-Mail Address",
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black54,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new email address';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          onTap: () {
                            _animationController
                                .stop(); // Arrêter l'animation lors de la saisie
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "You have to confirm your e-mail address after a change. We will send you an e-mail for this purpose. Simply click on the link in the email and confirm your email address.",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Current Password",
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black54,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                          onTap: () {
                            _animationController
                                .stop(); // Arrêter l'animation lors de la saisie
                          },
                        ),
                        const SizedBox(height: 25),
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF50C2C9),
                                ),
                              )
                            : isSaved
                                ? Center(
                                    child: Lottie.asset(
                                      'assets/json/hh.json',
                                      width: 150,
                                      height: 150,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: handleSave,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF50C2C9),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Save",
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
