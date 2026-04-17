import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'loading_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _opacity = 1;
        });
      }
    });

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoadingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🌸 SOFT PEACH THEME
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF4EC), // soft warm white-peach
              Color(0xFFFFE2CC), // soft peach
              Color(0xFFFFD6B5), // slightly deeper peach
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          children: [
            const Spacer(flex: 3),

            AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: _opacity,
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/images/icon.json',
                    width: 160,
                    repeat: true,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "FurEver",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 44,
                      fontWeight: FontWeight.bold,

                      // 🤍 softer contrast for peach background
                      color: Color(0xFF3A2E2A),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Connecting pets, creating FurEver friendships.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Color(0xFF5A4A45),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
