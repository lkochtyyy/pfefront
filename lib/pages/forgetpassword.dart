import 'package:flutter/material.dart';
import 'resetpassword.dart'; // Importez la page ResetPasswordScreen

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  String? _emailError;

  void _validateEmail() {
    setState(() {
      _emailController.text.trim();
      _emailError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3), // Matching background color
      body: Stack(
        children: [
          Positioned(
            top: -size.height * 0.05,
            left: -size.width * 0.05,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/shape.png',
                width: size.width * 0.6,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  Image.asset(
                    'assets/chorliya.png',
                    width: 400,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF50C2C9), // Sky blue theme color
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Entrez votre adresse e-mail pour réinitialiser votre mot de passe.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        hintText: 'Entrer votre adresse e-mail',
                        hintStyle: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Colors.black54),
                        errorText: _emailError,
                      ),
                      onChanged: (value) => _validateEmail(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF50C2C9), // Sky blue
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        _validateEmail();
                        if (_emailError == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordApp(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Envoyer',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
