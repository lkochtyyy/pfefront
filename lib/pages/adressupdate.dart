import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfefront/pages/editer.dart';

void main() {
  runApp(const MaterialApp(
    home: AddressUser(),
    debugShowCheckedModeBanner: false,
  ));
}

class AddressUser extends StatefulWidget {
  const AddressUser({super.key});

  @override
  State<AddressUser> createState() => _AddressUserState();
}

class _AddressUserState extends State<AddressUser>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final streetController = TextEditingController();
  final zipController = TextEditingController();
  final cityController = TextEditingController();

  String selectedCity = 'Kairouan';
  bool isSaved = false;
  bool isLoading = false;

  final Color customButtonColor = const Color(0xFF50C2C9);
  final List<String> tunisianCountry = ['Tunisia'];
  final List<String> tunisianCities = [
    'Tunis',
    'Ariana',
    'Ben Arous',
    'Manouba',
    'Nabeul',
    'Zaghouan',
    'Bizerte',
    'Béja',
    'Jendouba',
    'Kef',
    'Siliana',
    'Sousse',
    'Monastir',
    'Mahdia',
    'Kairouan',
    'Kasserine',
    'Sidi Bouzid',
    'Sfax',
    'Gabès',
    'Medenine',
    'Tataouine',
    'Gafsa',
    'Tozeur',
    'Kebili'
  ];

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _stopAnimation;

  FocusNode streetFocusNode = FocusNode();
  FocusNode zipFocusNode = FocusNode();

  @override
  void dispose() {
    streetController.dispose();
    zipController.dispose();
    cityController.dispose();
    _animationController.dispose();
    streetFocusNode.dispose();
    zipFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.1),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _stopAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.repeat(reverse: true);

    streetFocusNode.addListener(() {
      setState(() {
        if (streetFocusNode.hasFocus || zipFocusNode.hasFocus) {
          _animationController.stop();
        } else {
          _animationController.repeat(reverse: true);
        }
      });
    });

    zipFocusNode.addListener(() {
      setState(() {
        if (zipFocusNode.hasFocus || streetFocusNode.hasFocus) {
          _animationController.stop();
        } else {
          _animationController.repeat(reverse: true);
        }
      });
    });
  }

  void handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
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
              Text('Address updated successfully'),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.of(context).pushReplacement(_createRoute());
      }
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const UserAccountPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  InputDecoration customInputDecoration(String label, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        color: Colors.black87,
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
        title: const Text('Address', style: TextStyle(color: Colors.black87)),
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
                position: streetFocusNode.hasFocus || zipFocusNode.hasFocus
                    ? _stopAnimation
                    : _offsetAnimation,
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
                        DropdownButtonFormField<String>(
                          value: tunisianCountry.first,
                          decoration: customInputDecoration('Country'),
                          items: tunisianCountry
                              .map((country) => DropdownMenuItem(
                                    value: country,
                                    child: Text(country),
                                  ))
                              .toList(),
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedCity,
                                decoration: customInputDecoration('City'),
                                items: tunisianCities
                                    .map((city) => DropdownMenuItem(
                                          value: city,
                                          child: Text(city),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCity = value ?? 'Kairouan';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: zipController,
                                focusNode: zipFocusNode,
                                decoration: customInputDecoration('ZIP'),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: streetController,
                          focusNode: streetFocusNode,
                          decoration: customInputDecoration('Street'),
                          textInputAction: TextInputAction.done,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "This information is only required when you create an ad for a vehicle.",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: customButtonColor,
                                ),
                              )
                            : isSaved
                                ? Center(
                                    child: Lottie.asset('assets/json/hh.json',
                                        width: 150, height: 150),
                                  )
                                : ElevatedButton(
                                    onPressed: handleSave,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          customButtonColor.withOpacity(0.9),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(fontSize: 16),
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
}
