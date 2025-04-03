import 'package:flutter/material.dart';

void main() {
  runApp(const ResetPasswordApp());
}

class ResetPasswordApp extends StatelessWidget {
  const ResetPasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0F4F3), // Matching background color
      ),
      home: const ResetPasswordPage(),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _verificationFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mot de passe réinitialisé")),
      );
    }
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Image.asset('assets/chorliya.png', height: 300),
                    const SizedBox(height: 100),
                    _buildTextField(
                      "Code de vérification",
                      _verificationCodeController,
                      _verificationFocus,
                      nextFocusNode: _passwordFocus,
                    ),
                    _buildTextField(
                      "Mot de passe",
                      _passwordController,
                      _passwordFocus,
                      isPassword: true,
                      nextFocusNode: _confirmPasswordFocus,
                    ),
                    _buildTextField(
                      "Confirmer le mot de passe",
                      _confirmPasswordController,
                      _confirmPasswordFocus,
                      isPassword: true,
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF50C2C9), // Sky blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: _resetPassword,
                        child: const Text("Réinitialiser",
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, FocusNode focusNode,
      {bool isPassword = false,
      FocusNode? nextFocusNode,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: focusNode.hasFocus
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15, // Ombre plus large
                    spreadRadius: 3, // Ombre un peu plus étendue
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5, // Ombre moins prononcée lorsque le focus est absent
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: labelText,
            prefixIcon: Icon(
              isPassword ? Icons.lock : Icons.verified_user,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onEditingComplete: () {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              _resetPassword();
            }
          },
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                if (isPassword &&
                    controller == _confirmPasswordController &&
                    value != _passwordController.text) {
                  return 'Les mots de passe ne correspondent pas';
                }
                return null;
              },
        ),
      ),
    );
  }
}
