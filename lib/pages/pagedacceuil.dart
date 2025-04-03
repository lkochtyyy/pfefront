import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pfefront/pages/favoris.dart';
import 'package:pfefront/pages/messagerie.dart';
import 'package:pfefront/pages/publier.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pfefront/pages/search.dart';

class FeaturedCarsPage extends StatefulWidget {
  final String userId;
  const FeaturedCarsPage({super.key, required this.userId});

  @override
  _FeaturedCarsPageState createState() => _FeaturedCarsPageState();
}

class _FeaturedCarsPageState extends State<FeaturedCarsPage> {
  List<Map<String, dynamic>> cars = [
    {
      'title': 'BMW serie 2',
      'price': 180000,
      'status': 'NOUVEAU',
      'color': Colors.green,
      'image': 'assets/bmw s2.png'
    },
    {
      'title': 'C63 AMG',
      'price': 200000,
      'status': 'Ancien',
      'color': Colors.amber,
      'image': 'assets/C63 AMG.png'
    },
    {
      'title': 'Audi RS7',
      'price': 250000,
      'status': 'NOUVEAU',
      'color': Colors.blue,
      'image': 'assets/Audi RS7.png'
    },
    {
      'title': 'Mercedes G63',
      'price': 300000,
      'status': 'Ancien',
      'color': Colors.red,
      'image': 'assets/Mercedes G63.png'
    },
    {
      'title': 'Tesla Model S',
      'price': 350000,
      'status': 'NOUVEAU',
      'color': Colors.purple,
      'image': 'assets/Tesla Model S.png'
    },
    {
      'title': 'Porsche 911',
      'price': 400000,
      'status': 'Ancien',
      'color': Colors.orange,
      'image': 'assets/Porsche 911.png'
    },
  ];

  bool isAscending = true;
  String? filterStatus;

  void sortCars() {
    setState(() {
      cars.sort((a, b) => isAscending
          ? a['price'].compareTo(b['price'])
          : b['price'].compareTo(a['price']));
      isAscending = !isAscending;
    });
  }

  void filterCars(String? status) {
    setState(() {
      filterStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('User ID: ${widget.userId}');
    List<Map<String, dynamic>> displayedCars = filterStatus == null
        ? cars
        : cars.where((car) => car['status'] == filterStatus).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'Weelz TN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Chercher...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Featured catégories',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Row(children: [
                  IconButton(onPressed: sortCars, icon: const Icon(Icons.sort)),
                  PopupMenuButton<String>(
                    onSelected: filterCars,
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: null, child: Text('All')),
                      const PopupMenuItem(
                          value: 'NOUVEAU', child: Text('NOUVEAU')),
                      const PopupMenuItem(
                          value: 'Ancien', child: Text('Ancien')),
                    ],
                    icon: const Icon(Icons.filter_list),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: displayedCars.length,
                itemBuilder: (context, index) {
                  return carCard(displayedCars[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.directions_car), label: 'Vendre'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Chercher'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.paperPlane), label: 'Messagerie'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined), label: 'Favoris'),
      ],
      currentIndex: 2,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      onTap: (index) {
        Widget page;
        if (index == 0) {
          page = const PublierAnnoncePage();
        } else if (index == 1) {
          page = const SearchCarsPage();
        } else if (index == 4) {
          page = FavorisPage();
        } else if (index == 3) {
          page = const ChatsPage();
        } else {
          return;
        }

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: page,
            duration: const Duration(milliseconds: 300),
          ),
        );
      },
    );
  }

  Widget carCard(Map<String, dynamic> car) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading:
            Image.asset(car['image'], width: 50, height: 50, fit: BoxFit.cover),
        title: Text(car['title'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${car['price']} TND'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: car['color'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            car['status'],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
