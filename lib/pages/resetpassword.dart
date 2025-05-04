import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../blocs/resetpass/reset_password_bloc.dart';
import '../blocs/resetpass/reset_password_event.dart';
import '../blocs/resetpass/reset_password_state.dart';
import 'package:pfefront/pages/login.dart';

class ResetPasswordApp extends StatelessWidget {
  final String email;
  final String receivedcode;

  const ResetPasswordApp({
    super.key,
    required this.email,
    required this.receivedcode,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0F4F3),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: ResetPasswordPage(
        email: email,
        receivedcode: receivedcode,
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String receivedcode;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.receivedcode,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _verificationFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  double _scale = 1.0;
  bool _isLoading = false;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

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

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      context.read<ResetPasswordBloc>().add(
            UpdatePasswordEvent(
              email: widget.email,
              receivedcode: int.parse(widget.receivedcode),
              verificationCode: _verificationCodeController.text.trim(),
              newPassword: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Lottie.asset('assets/json/reset.json', height: 230),
                    const SizedBox(height: 40),
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
                    const SizedBox(height: 30),
                    BlocListener<ResetPasswordBloc, ResetPasswordState>(
                      listener: (context, state) async {
                        if (state is ResetPasswordSuccess) {
                          setState(() => _isLoading = false);

                          await showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30)),
                            ),
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/json/Locked.json',
                                      height: 150),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Mot de passe réinitialisé avec succès !',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => const LoginPage()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF50C2C9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                    child: const Text(
                                      'Revenir pour se connecter',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is ResetPasswordFailure) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      },
                      child: AnimatedScale(
                        scale: _scale,
                        duration: const Duration(milliseconds: 120),
                        child: GestureDetector(
                          onTapDown: _onTapDown,
                          onTapUp: _onTapUp,
                          onTapCancel: _onTapCancel,
                          onTap: _resetPassword,
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF50C2C9),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    "Réinitialiser",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: const Duration(seconds: 10),
      curve: Curves.easeInOut,
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    FocusNode focusNode, {
    bool isPassword = false,
    FocusNode? nextFocusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: focusNode.hasFocus
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword,
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
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(
              isPassword ? Icons.lock_outline : Icons.verified_user_outlined,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
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
