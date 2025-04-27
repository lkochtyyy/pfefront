import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfefront/pages/messagerie.dart';


void main() {
  runApp(const AddContactApp());
}


class AddContactApp extends StatelessWidget {
  const AddContactApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const AddContactScreen(),
    );
  }
}


class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});


  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}


class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();


  File? _selectedImage;
  bool _isLoading = false;
  final List<String> existingContacts = ['Alice', 'Bob', 'Charlie'];


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);


    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }


  void _startConversation() async {
    String name = _nameController.text.trim();
    String message = _messageController.text.trim();


    if (name.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }


    if (existingContacts.contains(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ce contact existe déjà.')),
      );
      return;
    }


    setState(() => _isLoading = true);


    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastContact', name);


    setState(() => _isLoading = false);


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChatsPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF50C2C9), Color(0xFFE1F5F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const ChatsPage()),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Nouveau contact',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: _selectedImage == null
                        ? const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    labelText: 'Nom du contact',
                    labelStyle: GoogleFonts.poppins(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: "Écrire un premier message...",
                    hintStyle: GoogleFonts.poppins(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    children: ['Salut !', 'On discute ?', 'Ça va ?'].map((msg) {
                      return ChoiceChip(
                        label: Text(msg, style: GoogleFonts.poppins()),
                        selected: _messageController.text == msg,
                        onSelected: (_) =>
                            setState(() => _messageController.text = msg),
                        selectedColor: const Color(0xFF50C2C9),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF50C2C9))
                    : ElevatedButton.icon(
                        onPressed: _startConversation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF50C2C9),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: Text(
                          "Commencer la conversation",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
