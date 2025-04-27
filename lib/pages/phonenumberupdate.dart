import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pfefront/pages/editer.dart';

class NumberUpdatePage extends StatefulWidget {
  const NumberUpdatePage({super.key});

  @override
  State<NumberUpdatePage> createState() => _NumberUpdatePageState();
}

class _NumberUpdatePageState extends State<NumberUpdatePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final oldNumberController = TextEditingController();
  final newNumberController = TextEditingController();
  final confirmationCodeController = TextEditingController();

  final FocusNode oldNumberFocusNode = FocusNode();
  final FocusNode newNumberFocusNode = FocusNode();
  final FocusNode codeFocusNode = FocusNode();

  bool isCodeVisible = false;
  bool isCodeValidated = false;
  bool isLoading = false;
  bool isSaved = false;
  bool isVerifying = false;

  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  late AnimationController _cardAnimationController;
  late Animation<Offset> _cardOffsetAnimation;
  bool isAnyFieldFocused = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();

    // Animation de flottement de la carte
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.015),
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _cardAnimationController.repeat(reverse: true);

    void handleFocusChange() {
      setState(() {
        isAnyFieldFocused = oldNumberFocusNode.hasFocus ||
            newNumberFocusNode.hasFocus ||
            codeFocusNode.hasFocus;
        if (isAnyFieldFocused) {
          _cardAnimationController.stop();
        } else {
          _cardAnimationController.repeat(reverse: true);
        }
      });
    }

    oldNumberFocusNode.addListener(handleFocusChange);
    newNumberFocusNode.addListener(handleFocusChange);
    codeFocusNode.addListener(handleFocusChange);
  }

  @override
  void dispose() {
    oldNumberController.dispose();
    newNumberController.dispose();
    confirmationCodeController.dispose();
    oldNumberFocusNode.dispose();
    newNumberFocusNode.dispose();
    codeFocusNode.dispose();
    _slideController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        isSaved = true;
        isLoading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => isSaved = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserAccountPage()),
        );
      }
    }
  }

  void handleVerifyCode() async {
    setState(() => isVerifying = true);
    await Future.delayed(const Duration(seconds: 2));

    if (confirmationCodeController.text == '1234') {
      setState(() {
        isCodeValidated = true;
        isVerifying = false;
      });
    } else {
      setState(() => isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Phone number updated successfully'),
            ],
          ),
        ),
      );
    }
  }

  Widget fadeSlideWrapper(Widget child, int index) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _slideController,
        curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final poppins = GoogleFonts.poppins();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Update Number', style: poppins),
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
                position: _cardOffsetAnimation,
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
                        fadeSlideWrapper(
                          TextFormField(
                            controller: oldNumberController,
                            focusNode: oldNumberFocusNode,
                            style: poppins,
                            decoration: _inputDecoration('Old Number'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Old number is required'
                                : null,
                            keyboardType: TextInputType.phone,
                          ),
                          0,
                        ),
                        const SizedBox(height: 20),
                        fadeSlideWrapper(
                          TextFormField(
                            controller: newNumberController,
                            focusNode: newNumberFocusNode,
                            style: poppins,
                            decoration: _inputDecoration('New Number'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'New number is required'
                                : null,
                            keyboardType: TextInputType.phone,
                          ),
                          1,
                        ),
                        const SizedBox(height: 20),
                        fadeSlideWrapper(
                          ElevatedButton(
                            onPressed: () {
                              setState(() => isCodeVisible = true);
                            },
                            style: _buttonStyle(enabled: true),
                            child: Text('Verify',
                                style: poppins.copyWith(fontSize: 16)),
                          ),
                          2,
                        ),
                        const SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: isCodeVisible
                              ? Column(
                                  key: const ValueKey('code_field'),
                                  children: [
                                    isVerifying
                                        ? const CircularProgressIndicator(
                                            color: Color(0xFF50C2C9),
                                          )
                                        : TextFormField(
                                            controller:
                                                confirmationCodeController,
                                            focusNode: codeFocusNode,
                                            style: poppins,
                                            decoration: _inputDecoration(
                                                'Confirmation Code'),
                                            keyboardType: TextInputType.number,
                                          ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: handleVerifyCode,
                                      style: _buttonStyle(enabled: true),
                                      child: Text(
                                        'Confirm Code',
                                        style: poppins.copyWith(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: isCodeValidated ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 400),
                          child: isCodeValidated
                              ? Text(
                                  'Code Verified',
                                  style: poppins.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          child: isLoading
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
                                  : ElevatedButton.icon(
                                      key: const ValueKey('save_button'),
                                      onPressed:
                                          isCodeValidated ? handleSave : null,
                                      icon: const Icon(Icons.save),
                                      label: Text('Save',
                                          style:
                                              poppins.copyWith(fontSize: 16)),
                                      style: _buttonStyle(
                                          enabled: isCodeValidated),
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
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF50C2C9)),
      ),
    );
  }

  ButtonStyle _buttonStyle({required bool enabled}) {
    return ElevatedButton.styleFrom(
      backgroundColor: enabled ? const Color(0xFF50C2C9) : Colors.grey.shade400,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 4,
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
