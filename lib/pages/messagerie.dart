import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pfefront/pages/add.dart';


class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});


  @override
  State<ChatsPage> createState() => _ChatsPageState();
}


class _ChatsPageState extends State<ChatsPage> {
  final List<String> messages = const []; // simule une liste vide
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF50C2C9),
                  Color(0xFFE1F5F7),
                  Color.fromARGB(255, 235, 237, 243),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildAnimatedAppBar(),
                    const SizedBox(height: 0.1),
                    Expanded(
                      child: messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/json/message.json',
                                    width: 300,
                                    height: 300,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Aucun message trouvé',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return _buildChatItem(context, index);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),


          // -------- FloatingActionButton animé avec Lottie --------
          Positioned(
            bottom: 1.0, // Distance du bas de l'écran
            right: 1.0, // Distance du côté droit de l'écran
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddContactApp()),
                );
              },
              child: SizedBox(
                width: 150, // Ajuste la taille de l'animation
                height: 150,
                child: Lottie.asset(
                  'assets/json/text.json',
                  fit: BoxFit.contain,
                  repeat:
                      true, // ou false si tu veux juste une animation une seule fois
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAnimatedAppBar() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1.0,
        child: child,
      ),
      child: _isSearching ? _buildSearchField() : _buildTitleBar(),
    );
  }


  Widget _buildTitleBar() {
    return AppBar(
      key: const ValueKey('titleAppBar'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Messages',
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ],
    );
  }


  Widget _buildSearchField() {
    return AppBar(
      key: const ValueKey('searchAppBar'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        cursorColor: Colors.black,
      ),
    );
  }


  Widget _buildChatItem(BuildContext context, int index) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            'Mohamed Ali',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Last message preview...',
            style: GoogleFonts.poppins(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddContactApp()),
            );
          },
        ),
        const Divider(thickness: 0.5, indent: 16, endIndent: 16),
      ],
    );
  }
}
