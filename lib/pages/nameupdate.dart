import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pfefront/pages/editer.dart';
import 'package:google_fonts/google_fonts.dart';

class NameUser extends StatefulWidget {
  const NameUser({super.key});

  @override
  State<NameUser> createState() => _NameUserState();
}

class _NameUserState extends State<NameUser>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? selectedSalutation = 'Not specified';
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool showInListings = true;
  bool isPrivacyEnabled = false;
  bool isSaved = false;
  bool isLoading = false;

  bool isFocused = false; // Flag to track focus state

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _stopAnimation;

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    _animationController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Animation controller for translation
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.1),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _stopAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0), // No translation when focused
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.repeat(reverse: true);

    // Focus node listeners to stop translation when focused
    firstNameFocusNode.addListener(() {
      if (firstNameFocusNode.hasFocus) {
        setState(() {
          isFocused = true;
        });
      } else {
        setState(() {
          isFocused = false;
        });
      }
    });

    lastNameFocusNode.addListener(() {
      if (lastNameFocusNode.hasFocus) {
        setState(() {
          isFocused = true;
        });
      } else {
        setState(() {
          isFocused = false;
        });
      }
    });
  }

  void handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        isSaved = true;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Saved successfully'),
            ],
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isSaved = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserAccountApp()),
        );
      });
    }
  }

  InputDecoration customInputDecoration(String label, String? hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: Colors.black87,
        fontFamily:
            GoogleFonts.poppins().fontFamily, // Appliquer la police Poppins
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Edit Name',
          style: TextStyle(color: Colors.black87),
        ),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
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
                            Hero(
                              tag: 'salutation-hero',
                              child: DropdownButtonFormField<String>(
                                value: selectedSalutation,
                                decoration:
                                    customInputDecoration('Salutation', null),
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins()
                                      .fontFamily, // Appliquer la police Poppins
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'Not specified',
                                      child: Text('Not specified')),
                                  DropdownMenuItem(
                                      value: 'Mr.', child: Text('Mr.')),
                                  DropdownMenuItem(
                                      value: 'Ms.', child: Text('Ms.')),
                                ],
                                onChanged: (value) {
                                  setState(() => selectedSalutation = value);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Hero(
                              tag: 'first-name-hero',
                              child: TextFormField(
                                controller: firstNameController,
                                focusNode: firstNameFocusNode,
                                decoration: customInputDecoration(
                                  'First Name',
                                  isPrivacyEnabled ? 'Hidden' : 'Barhoumi',
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'First name is required'
                                        : null,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Hero(
                              tag: 'last-name-hero',
                              child: TextFormField(
                                controller: lastNameController,
                                focusNode: lastNameFocusNode,
                                decoration: customInputDecoration(
                                  'Last Name',
                                  isPrivacyEnabled ? 'Hidden' : 'Hechem',
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Last name is required'
                                        : null,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CheckboxListTile(
                              value: showInListings,
                              onChanged: (value) => setState(
                                  () => showInListings = value ?? true),
                              title: const Text('Show in listings'),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: const Color(0xFF50C2C9),
                            ),
                            const SizedBox(height: 20),
                            CheckboxListTile(
                              value: isPrivacyEnabled,
                              onChanged: (value) => setState(
                                  () => isPrivacyEnabled = value ?? false),
                              title: const Text('Enable Privacy (Hide Name)'),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: const Color(0xFF50C2C9),
                            ),
                            const SizedBox(height: 20),
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Color(0xFF50C2C9)))
                                : isSaved
                                    ? Center(
                                        child: Lottie.asset(
                                            'assets/json/hh.json',
                                            width: 150,
                                            height: 150))
                                    : ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF50C2C9),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                        onPressed: handleSave,
                                        icon: const Icon(Icons.save),
                                        label: const Text('Save',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
