import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAvatar {
  static ValueNotifier<String?> avatarPath = ValueNotifier<String?>(null);
}

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen>
    with SingleTickerProviderStateMixin {
  int? selectedIndex;
  final List<String> avatarPaths = List.generate(
    12,
    (index) => 'assets/avatars/avatar_${index + 1}.png',
  );

  late AnimationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedAvatar();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
  }

  Future<void> _loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('selected_avatar');
    setState(() {
      selectedIndex = savedIndex;
    });
  }

  Future<void> _saveSelectedAvatar(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_avatar', index);
    await prefs.setString('selected_avatar_path', avatarPaths[index]);
  }

  Future<void> _removeSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_avatar');
    await prefs.remove('selected_avatar_path');
    setState(() => selectedIndex = null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                0.5 * sin(_controller.value * 2 * pi),
                0.5 * cos(_controller.value * 2 * pi),
              ),
              radius: 1.2,
              colors: [
                const Color(0xFF50C2C9),
                const Color.fromARGB(255, 235, 237, 243),
                const Color(0xFFE1F5F7),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedAvatar =
        selectedIndex != null ? avatarPaths[selectedIndex!] : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          'Select Avatar',
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _removeSelectedAvatar,
          )
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Column(
            children: [
              const SizedBox(height: 120),
              Text(
                'Choose Your Character',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator(),
              const SizedBox(height: 20),
              if (selectedAvatar != null)
                Hero(
                  tag: 'selected-avatar',
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(selectedAvatar),
                    backgroundColor: Colors.white,
                  ),
                ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 82, 188, 194),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Character",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: characterGrid()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () async {
                    if (selectedIndex != null) {
                      setState(() {
                        _isLoading = true;
                      });
                      await _saveSelectedAvatar(selectedIndex!);
                      UserAvatar.avatarPath.value = avatarPaths[selectedIndex!];
                      Navigator.pop(context);
                    }
                  },
                  label: const Text("Done"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF50C2C9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              if (selectedIndex != null)
                TextButton(
                  onPressed: _removeSelectedAvatar,
                  child: Text(
                    "Remove selected",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF50C2C9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget characterGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: avatarPaths.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() => selectedIndex = index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
              ],
              border: Border.all(
                color: isSelected ? Colors.green : Colors.transparent,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(avatarPaths[index]),
            ),
          ),
        );
      },
    );
  }
}
