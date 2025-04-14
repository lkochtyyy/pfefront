import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrendingProductsPage(),
    );
  }
}

class TrendingProductsPage extends StatefulWidget {
  const TrendingProductsPage({super.key});

  @override
  State<TrendingProductsPage> createState() => _TrendingProductsPageState();
}

class _TrendingProductsPageState extends State<TrendingProductsPage> {
  int _currentIndex = 2;

  final List<Map<String, dynamic>> cars = [
    {
      'image': 'assets/AUDI RS5.png',
      'title': 'AUDI RS5 2023',
      'price': 25000,
    },
    {
      'image': 'assets/BMW M4.png',
      'title': 'BMW X5',
      'price': 45000,
    },
    {
      'image': 'assets/C63 AMG.png',
      'title': 'C63 AMG',
      'price': 60000,
    },
    {
      'image': 'assets/bmw s2.png',
      'title': 'Toyota Corolla',
      'price': 20000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.menu, size: 28),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/image 17.png'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search any Product..',
                    border: InputBorder.none,
                    suffixIcon: Icon(CupertinoIcons.mic),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All featured',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Color.fromARGB(255, 110, 224, 230),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.sort, size: 16),
                        label: const Text("Sort"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Color.fromARGB(255, 110, 224, 230),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.filter_alt_outlined, size: 16),
                        label: const Text("Filter"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Fixed the Expanded widget to account for bottom navigation
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 20), // Added bottom padding
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75, // Adjusted aspect ratio for better card sizing
                  ),
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    return CarCard(car: cars[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF50C2C9),
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: [
            _buildNavItem(icon: Icons.publish, label: 'Publier', index: 0),
            _buildNavItem(icon: Icons.favorite_border, label: 'Favoris', index: 1),
            _buildNavItem(icon: Icons.home, label: 'Home', index: 2),
            _buildNavItem(icon: Icons.message_outlined, label: 'Messagerie', index: 3),
            _buildNavItem(icon: Icons.settings_outlined, label: 'Paramètres', index: 4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF50C2C9).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          Icon(icon),
        ],
      ),
      label: label,
    );
  }
}

class CarCard extends StatelessWidget {
  final Map<String, dynamic> car;
  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color : Colors.white ,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    car['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            car['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.star, size: 16, color: Colors.black87),
              SizedBox(width: 4),
              Text(
                "4.5",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(width: 6),
              Chip(
                label: Text(
                  'New',
                  style: TextStyle(fontSize: 12 ,
                  color : Colors.black87),
                ),
              
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                backgroundColor: Color.fromARGB(255, 110, 224, 230),
                shape: StadiumBorder(),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "\$${car['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}