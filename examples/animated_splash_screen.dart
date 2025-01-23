import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}
//
// Created by CodeWithFlexZ
// Tutorials on my YouTube
//
//! Instagram
//! @CodeWithFlexZ
//
//? GitHub
//? AmirBayat0
//
//* YouTube
//* Programming with FlexZ
//

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapping the app in MaterialApp to manage app-wide configurations
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Initial screen is the splash screen
    );
  }
}

// SplashScreen widget handles the initial screen and animation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  late AnimationController _moveController;
  late Animation<Offset> _moveAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation animation setup
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: -45 * pi / 180).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // Move animation setup
    _moveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _moveAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(5, -6),
    ).animate(
        CurvedAnimation(parent: _moveController, curve: Curves.easeInOut));

    // Trigger animation sequence after a delay
    _startAnimations();
  }

  // Start the animation sequence
  void _startAnimations() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      _rotationController.forward().then((_) {
        Future.delayed(const Duration(seconds: 1)).then((_) async {
          await _moveController.forward();
          // Navigate to HomePage after the animations
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (_) => const HomePage()));
        });
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWithFlame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100), // Space before logo

          // Animated title text with fade out effect
          FadeOut(
            animate: true,
            delay: const Duration(seconds: 5),
            duration: const Duration(seconds: 1),
            child: Text(
              "Transfelry",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 120), // Space before plane animation

          // Animated plane icon with rotation and translation
          AnimatedBuilder(
            animation: Listenable.merge([_rotationController, _moveController]),
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: FractionalTranslation(
                    translation: _moveAnimation.value, child: child),
              );
            },
            child: Image.asset(
              'assets/icons/plane.png',
              width: double.infinity,
              height: 400,
            ),
          ),

          const SizedBox(height: 130), // Space after plane animation

          // Animated developer signature text with fade out effect
          FadeOut(
            animate: true,
            delay: const Duration(seconds: 5),
            duration: const Duration(seconds: 1),
            child: Text(
              "Made By @CodeWithFlexz",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple HomePage to navigate to after splash screen
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Home Page",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Custom background widget with flame effect
class BackgroundWithFlame extends StatelessWidget {
  const BackgroundWithFlame({super.key, required this.child, this.appBar});

  final Widget child;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        bottom: false,
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Positioned flame image at the bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset('assets/icons/flame.png'),
              ),
              // The main body with the child widget
              Positioned.fill(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
