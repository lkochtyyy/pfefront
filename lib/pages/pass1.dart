import 'package:flutter/material.dart';
import 'welcome.dart'; // Import the WelcomeScreen

void main() {
  runApp(const MyApp());
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 350),
        const SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF50C2C9), // Theme color
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Onboarding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 24),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Choisissez une voiture",
      "description":
          "Explorez et trouvez la voiture parfaite pour vous ! Comparez les résultats et prenez des décisions éclairées.",
      "image": "assets/image11.png",
    },
    {
      "title": "Contacter le vendeur",
      "description":
          "Contactez facilement les vendeurs pour poser des questions et finaliser votre achat.",
      "image": "assets/image22.png",
    },
    {
      "title": "Obtenez votre voiture",
      "description":
          "Finalisez votre achat et repartez avec la voiture de vos rêves.",
      "image": "assets/image33.png",
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToWelcome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3), // Updated theme background
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: _onboardingData[index]["title"]!,
                description: _onboardingData[index]["description"]!,
                image: _onboardingData[index]["image"]!,
              );
            },
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: TextButton(
              onPressed: _goToWelcome,
              child: const Text(
                "Passer",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: _prevPage,
                    child: const Text(
                      "Précédent",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                if (_currentPage == 0) const SizedBox(width: 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFF50C2C9) // Updated theme color
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                TextButton(
                  onPressed: _currentPage == _onboardingData.length - 1
                      ? _goToWelcome
                      : _nextPage,
                  child: Text(
                    _currentPage == _onboardingData.length - 1
                        ? "Démarrer"
                        : "Suivant",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF50C2C9), // Updated theme color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
