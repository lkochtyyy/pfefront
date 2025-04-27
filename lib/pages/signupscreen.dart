import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../data/models/user_model.dart';
import 'package:pfefront/pages/pagedacceuil.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});


  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? inputType;
  final bool isPassword;
  final Function(String)? onChanged;
  final TextStyle? style;


  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.inputType,
    this.isPassword = false,
    this.onChanged,
    this.style,
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPassword,
      onChanged: onChanged,
      style: style ?? GoogleFonts.poppins(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
        ),
      ),
    );
  }
}


class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();


  bool _isPasswordMatch = true;


  void _validatePasswords() {
    setState(() {
      _isPasswordMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }


  void _registerUser(BuildContext context) {
    if (_formKey.currentState!.validate() && _isPasswordMatch) {
      final user = UserModel(
        
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        tel: _telController.text,
        password: _passwordController.text,
      );


      context.read<AuthBloc>().add(RegisterUser(user));
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3),
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
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green),
                      );
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        isScrollControlled: true,
                        builder: (_) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset('assets/json/done.json',
                                  height: 150),
                              const SizedBox(height: 12),
                              Text(
                                'Bienvenue dans CARZone !',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 4), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FeaturedCarsPage(userId: state.userId)),
                        );
                      });
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 180),
                            SizedBox(
                              height: 150,
                              child: AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 800),
                                child:
                                    Lottie.asset('assets/json/register.json'),
                              ),
                            ),
                            Text(
                              "Rejoignez-nous !",
                              style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF50C2C9)),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _nomController,
                              hintText: "Nom",
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _prenomController,
                              hintText: "Prénom",
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _emailController,
                              hintText: "Email",
                              inputType: TextInputType.emailAddress,
                              icon: Icons.email,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _telController,
                              hintText: "Téléphone",
                              inputType: TextInputType.phone,
                              icon: Icons.phone,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: "Mot de passe",
                              isPassword: true,
                              icon: Icons.lock,
                              onChanged: (value) => _validatePasswords(),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _confirmPasswordController,
                              hintText: "Confirmer mot de passe",
                              isPassword: true,
                              icon: Icons.lock,
                              onChanged: (value) => _validatePasswords(),
                            ),
                            if (!_isPasswordMatch)
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Les mots de passe ne correspondent pas",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xFF50C2C9), // Couleur de fond
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // Coins arrondis similaires
                                    // Bordure blanche
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: state is AuthLoading
                                    ? null
                                    : () => _registerUser(context),
                                child: state is AuthLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        "Créer mon compte",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



