import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/pages/pagedacceuil.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../data/models/user_model.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordMatch = true;

  void _validatePasswords() {
    setState(() {
      _isPasswordMatch = _passwordController.text == _confirmPasswordController.text;
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeaturedCarsPage(userId: state.userId),
                      ),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error), backgroundColor: Colors.red),
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
                          const Text(
                            "Rejoignez-nous !",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF50C2C9),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _nomController,
                            hintText: "Nom",
                            icon: Icons.person,
                          ),
                          CustomTextField(
                            controller: _prenomController,
                            hintText: "Prénom",
                            icon: Icons.person,
                          ),
                          CustomTextField(
                            controller: _emailController,
                            hintText: "Email",
                            inputType: TextInputType.emailAddress,
                            icon: Icons.email,
                          ),
                          CustomTextField(
                            controller: _telController,
                            hintText: "Téléphone",
                            inputType: TextInputType.phone,
                            icon: Icons.phone,
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: "Mot de passe",
                            isPassword: true,
                            icon: Icons.lock,
                            onChanged: (value) => _validatePasswords(),
                          ),
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
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF50C2C9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: state is AuthLoading ? null : () => _registerUser(context),
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "Créer mon compte",
                                      style: TextStyle(
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
    );
  }
}