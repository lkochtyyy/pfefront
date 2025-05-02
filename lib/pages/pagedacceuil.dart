import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pfefront/blocs/favoris/favori_bloc.dart';
import 'package:pfefront/blocs/favoris/favori_event.dart';
import 'package:pfefront/blocs/favoris/favori_state.dart';
import 'package:pfefront/pages/chatbot.dart';
import 'package:pfefront/pages/favoris.dart';
import 'package:pfefront/pages/messagerie.dart';
import 'package:pfefront/pages/editprofile.dart';
import 'package:pfefront/pages/notification.dart';
import 'package:pfefront/pages/profilepicture.dart';
import 'package:pfefront/pages/publier.dart';
import 'package:pfefront/pages/search.dart';
import 'package:pfefront/pages/filtrage.dart';
import 'package:pfefront/pages/viewpub.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:pfefront/blocs/announcement/car_announcement_bloc.dart';
import 'package:pfefront/data/models/announcement_model.dart';

class FeaturedCarsPage extends StatefulWidget {
  const FeaturedCarsPage({super.key});

  @override
  State<FeaturedCarsPage> createState() => _FeaturedCarsPageState();
}

class _FeaturedCarsPageState extends State<FeaturedCarsPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';
  bool isAscending = true;
  List<int> favorisIds = [];
  bool isFavorisLoading = true;

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    // Add logic to start speech recognition here
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    // Add logic to stop speech recognition here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserIdAndFetchAnnouncements(); // Fetch announcements and favorites
  }

  Future<void> _loadUserIdAndFetchAnnouncements() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Retrieve userId

    if (userId != null) {
      // Fetch user's favorites
      context.read<FavoriBloc>().add(GetFavoris(int.parse(userId)));

      // Fetch car announcements
      context.read<CarAnnouncementBloc>().add(FetchAnnouncements());
    } else {
      print('Error: userId not found in SharedPreferences.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriBloc, FavoriState>(
      listener: (context, state) {
        if (state is FavoriLoaded) {
          setState(() {
            favorisIds = state.favoris.map((f) => f.carId).toList();
            isFavorisLoading = false; // Les favoris sont chargés
          });
        } else if (state is FavoriLoading) {
          setState(() {
            isFavorisLoading = true; 
            print("te7cheeeeeee");
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildAnimatedBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 20),
                  _buildSearchField(context),
                  const SizedBox(height: 20),
                  _buildFeaturedSection(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<CarAnnouncementBloc, CarAnnouncementState>(
                        builder: (context, state) {
                          if (isFavorisLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (state is CarAnnouncementLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is CarAnnouncementLoaded) {
                            print("Search Text: $_searchText");
print("Announcements: ${state.announcements.map((a) => a.title).toList()}");
                            // Filter announcements by search text
                            final List<CarAnnouncement> list = state.announcements
                                .where((a) => a.title
                                    .toLowerCase()
                                    .contains(_searchText.toLowerCase()))
                                .toList();
                            return GridView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final car = list[index];
                                final imageUrl = car.imageUrl;

                                return Stack(
                                  children: [
                                    CarCard(
                                      data: {
                                        'id': car.id,
                                        'title': car.title,
                                        'price': car.price,
                                        'status': car.carCondition,
                                        'image': imageUrl,
                                      },
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CarDetailPage(annonceId: '${car.id}'),
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: IconButton(
                                        icon: Icon(
                                          favorisIds.contains(car.id)
                                              ? Icons.favorite // ❤️ filled
                                              : Icons.favorite_border, // 🤍 empty
                                          color: const Color.fromARGB(255, 250, 2, 2),
                                        ),
                                        onPressed: () async {
                                          final prefs = await SharedPreferences.getInstance();
                                          final userId = prefs.getString('userId');
                                          if (userId != null) {
                                            final isFavori = favorisIds.contains(car.id);
                                            if (!isFavori) {
                                              context.read<FavoriBloc>().add(
                                                AjouterFavori(carId: car.id!, userId: int.parse(userId)),
                                              );
                                              setState(() => favorisIds.add(car.id!));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Added to favorites')),
                                              );
                                            } else {
                                              context.read<FavoriBloc>().add(
                                                SupprimerFavori(carId: car.id!, userId: int.parse(userId)),
                                              );
                                              setState(() => favorisIds.remove(car.id!));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Removed from favorites')),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('User not identified')),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (state is CarAnnouncementError) {
                            return Center(child: Text('Error: ${state.error}'));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 13,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 600),
                      pageBuilder: (_, __, ___) => const ChatBotSupportPage(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Hero(
                      tag: 'chatbot_button',
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: ClipOval(
                          child: SizedBox(
                            height: 85,
                            width: 85,
                            child: Lottie.asset(
                              'assets/json/chatbot.json',
                              fit: BoxFit.cover,
                              repeat: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
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

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'CARZone',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: const Color.fromARGB(255, 9, 5, 5),
          fontSize: 24,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPage(),
              ),
            );
          },
        ),
        ValueListenableBuilder<String?>(
          valueListenable: UserAvatar.avatarPath,
          builder: (context, avatar, _) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: avatar != null ? AssetImage(avatar) : null,
                  child: avatar == null
                      ? const Icon(Icons.person, color: Colors.black)
                      : null,
                ),
              ),
            );
          },
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).push(_createSearchRoute());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.2,
            ),
          ),
          child: IgnorePointer(
            child: TextField(
              enabled: false,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search any Product..',
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Featured Cars',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () => _showFilterSheet(),
            icon: const Icon(Icons.filter_alt_outlined, size: 18),
            label: Text(
              "Filter",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Options',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Add filter options here
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF50C2C9),
      unselectedItemColor: Colors.black.withOpacity(0.6),
      showUnselectedLabels: true,
      elevation: 12,
      iconSize: 30,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Publish',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email_rounded),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars_rounded),
          label: 'Favorites',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PublierAnnoncePage()),
            );
            break;

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatsPage()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavorisPage()),
            );
            break;
        }
      },
    );
  }
}

class CarCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const CarCard({
    super.key, 
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final image = data['image'] as String;
    final priceFormatted = "\$${data['price'].toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    )}";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.45, // Limit card width
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Important to prevent overflow
          children: [
            // Image container with fixed aspect ratio
            AspectRatio(
              aspectRatio: 1.5,
              child: Hero(
                tag: 'car-image-${data['id']}',
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: image.startsWith('http')
                          ? Image.network(
                              image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                       
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Title with max lines
            Text(
              data['title'],
              style: GoogleFonts.poppins(
                fontSize: 16, 
                fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Rating and status row
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  "4.5",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(width: 6),
                const Text(
                  "|",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 9),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(data['status']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      data['status'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusTextColor(data['status']),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Price with better formatting
            Text(
              priceFormatted,
              style: GoogleFonts.poppins(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Colors.green[800]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue.shade100;
      case 'used':
        return Colors.grey.shade300;
      case 'certified':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue.shade800;
      case 'used':
        return Colors.black87;
      case 'certified':
        return Colors.green.shade800;
      default:
        return Colors.black87;
    }
  }
}
Route _createSearchRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SearchCarsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffset = Offset(0.0, 1.0);
      const endOffset = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: beginOffset, end: endOffset)
          .chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}