import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:pfefront/blocs/userupdate/user_update_bloc.dart';
import 'package:pfefront/blocs/userupdate/user_update_event.dart';
import 'package:pfefront/blocs/userupdate/user_update_state.dart';
import 'package:pfefront/utils/shared_prefs_helper.dart';


class PasswordUpdateUser extends StatefulWidget {
  const PasswordUpdateUser({super.key});

  @override
  State<PasswordUpdateUser> createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends State<PasswordUpdateUser>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();

  bool obscureNew = true;
  bool obscureCurrent = true;
  bool hasMinLength = false;
  bool hasLetters = false;
  bool hasSpecials = false;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _stopAnimation;
  bool isFocused = false;

  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode currentPasswordFocusNode = FocusNode();

  void updatePasswordCriteria(String value) {
    setState(() {
      hasMinLength = value.length >= 8;
      hasLetters = RegExp(r'[A-Za-z]').hasMatch(value);
      hasSpecials = RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]').hasMatch(value);
    });
  }

  Future<void> handleSave() async {
    if (_formKey.currentState!.validate()) {
       final idStr = await SharedPrefsHelper.getUserId();
       final userId = int.tryParse(idStr ?? '');
      if (userId != null) {
        // Use the retrieved userId directly
        BlocProvider.of<UserUpdateBloc>(context).add(
          UpdatePasswordevent(
            userId,
            newPasswordController.text.trim(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Impossible de récupérer votre identifiant')),
        );
      }
    } else {
      _animationController.forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.1),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));

    _stopAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));

    _animationController.repeat(reverse: true);

    newPasswordFocusNode.addListener(() {
      setState(() {
        isFocused = newPasswordFocusNode.hasFocus;
      });
    });

    currentPasswordFocusNode.addListener(() {
      setState(() {
        isFocused = currentPasswordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    currentPasswordController.dispose();
    _animationController.dispose();
    newPasswordFocusNode.dispose();
    currentPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserUpdateBloc, UserUpdateState>(
      listener: (context, state) async {
        if (state is UserUpdateLoading) {
          // Optionnel: peut afficher une animation de loading si tu veux
        } else if (state is UserUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) Navigator.pop(context);
        } else if (state is UserUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Password', style: GoogleFonts.poppins(color: Colors.black87)),
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
                onTap: () => FocusScope.of(context).unfocus(),
                child: SlideTransition(
                  position: isFocused ? _stopAnimation : _offsetAnimation,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.black12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("New Password", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: obscureNew,
                            focusNode: newPasswordFocusNode,
                            onChanged: updatePasswordCriteria,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              suffixIcon: IconButton(
                                icon: Icon(obscureNew ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => setState(() => obscureNew = !obscureNew),
                              ),
                              hintText: 'Enter new password',
                              filled: true,
                              fillColor: Colors.blue.withOpacity(0.1),
                            ),
                            validator: (value) {
                              if (!hasMinLength || !hasLetters || !hasSpecials) {
                                return 'Password must have at least 8 characters, include letters and special characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(children: [Icon(Icons.check, color: hasMinLength ? Colors.green : Colors.grey), const SizedBox(width: 5), Text('At least 8 characters', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54))]),
                          Row(children: [Icon(Icons.check, color: hasLetters ? Colors.green : Colors.grey), const SizedBox(width: 5), Text('Contains letters', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54))]),
                          Row(children: [Icon(Icons.check, color: hasSpecials ? Colors.green : Colors.grey), const SizedBox(width: 5), Text('Contains special characters', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54))]),
                          const SizedBox(height: 10),
                          Text("Current Password", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: currentPasswordController,
                            obscureText: obscureCurrent,
                            focusNode: currentPasswordFocusNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              suffixIcon: IconButton(
                                icon: Icon(obscureCurrent ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => setState(() => obscureCurrent = !obscureCurrent),
                              ),
                              hintText: 'Enter current password',
                              filled: true,
                              fillColor: Colors.blue.withOpacity(0.1),
                            ),
                            validator: (value) => value == null || value.isEmpty ? 'Enter your current password' : null,
                          ),
                          const SizedBox(height: 25),
                          BlocBuilder<UserUpdateBloc, UserUpdateState>(
                            builder: (context, state) {
                              if (state is UserUpdateLoading) {
                                return const Center(child: CircularProgressIndicator(color: Color(0xFF50C2C9)));
                              } else if (state is UserUpdateSuccess) {
                                return Center(child: Lottie.asset('assets/json/hh.json', width: 150, height: 150));
                              }
                              return ElevatedButton(
                                onPressed: handleSave,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF50C2C9),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  shadowColor: Colors.black54,
                                  elevation: 5,
                                ),
                                child: Text("Save", style: GoogleFonts.poppins(fontSize: 16)),
                              );
                            },
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
      ),
    );
  }
}
