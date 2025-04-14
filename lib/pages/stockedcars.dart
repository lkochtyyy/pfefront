import 'package:flutter/material.dart';

class StockedCars extends StatelessWidget {
  const StockedCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voitures Vedettes"),
      ),
      body: const Center(
        child: Text(
          "Page des voitures vedettes",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
