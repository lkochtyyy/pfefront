import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'pagedacceuil.dart';

class LoadingTransitionPage extends StatefulWidget {
  final int userId;

  const LoadingTransitionPage({super.key, required this.userId});

  @override
  State<LoadingTransitionPage> createState() => _LoadingTransitionPageState();
}

class _LoadingTransitionPageState extends State<LoadingTransitionPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FeaturedCarsPage(
            userId: widget.userId.toString(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/json/hello.json',
          width: 400,
          height: 400,
          repeat: false,
        ),
      ),
    );
  }
}
