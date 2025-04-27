import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pfefront/blocs/userupdate/user_update_bloc.dart';
import 'package:pfefront/blocs/userupdate/user_update_event.dart';
import 'package:pfefront/blocs/userupdate/user_update_state.dart';
import 'package:pfefront/pages/editer.dart';
import 'package:pfefront/utils/shared_prefs_helper.dart';


class NameUser extends StatefulWidget {
  const NameUser({Key? key}) : super(key: key);

  @override
  State<NameUser> createState() => _NameUserState();
}

class _NameUserState extends State<NameUser> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _stopAnimation;

  bool isFocused = false;
  String? selectedSalutation = 'Not specified';

  @override
  void initState() {
    super.initState();

    // Animation flottante
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.1),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _stopAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    firstNameFocusNode.addListener(_onFocusChange);
    lastNameFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      isFocused = firstNameFocusNode.hasFocus || lastNameFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    super.dispose();
  }

  Future<void> handleSave(BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;

    final idStr = await SharedPrefsHelper.getUserId();
    final userId = int.tryParse(idStr ?? '');
    if (userId == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Erreur: ID utilisateur introuvable")),
      );
      return;
    }

    // On envoie d'abord le nom, puis le prénom
    final bloc = ctx.read<UserUpdateBloc>();
    bloc.add(UpdateNomEvent(userId, lastNameController.text.trim()));
    bloc.add(UpdatePrenomEvent(userId, firstNameController.text.trim()));
  }

  InputDecoration customInputDecoration(String label, String? hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: Colors.black87,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF50C2C9), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserUpdateBloc, UserUpdateState>(
      listener: (ctx, state) {
        if (state is UserUpdateSuccess) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 10),
                  Text(state.message),
                ],
              ),
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              ctx,
              MaterialPageRoute(builder: (_) => const UserAccountPage()),
            );
          });
        } else if (state is UserUpdateFailure) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(state.error),
                ],
              ),
            ),
          );
        }
      },
      builder: (ctx, state) {
        final isLoading = state is UserUpdateLoading;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Edit Name', style: TextStyle(color: Colors.black87)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.black87,
          ),
          body: Stack(
            children: [
              Container(
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
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: SlideTransition(
                    position: isFocused ? _stopAnimation : _offsetAnimation,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(blurRadius: 12, color: Colors.black12, offset: Offset(0, 6)),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedSalutation,
                              decoration: customInputDecoration('Salutation', null),
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Not specified', child: Text('Not specified')),
                                DropdownMenuItem(value: 'Mr.', child: Text('Mr.')),
                                DropdownMenuItem(value: 'Ms.', child: Text('Ms.')),
                                DropdownMenuItem(value: 'Dr.', child: Text('Dr.')),
                              ],
                              onChanged: (v) => setState(() => selectedSalutation = v),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: lastNameController,
                              focusNode: lastNameFocusNode,
                              decoration: customInputDecoration('Last Name', 'Enter your last name'),
                              validator: (v) => v == null || v.isEmpty ? 'Please enter your last name' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: firstNameController,
                              focusNode: firstNameFocusNode,
                              decoration: customInputDecoration('First Name', 'Enter your first name'),
                              validator: (v) => v == null || v.isEmpty ? 'Please enter your first name' : null,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.save_alt_rounded),
                              onPressed: isLoading ? null : () => handleSave(ctx),
                              label: const Text("Save"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF50C2C9),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
