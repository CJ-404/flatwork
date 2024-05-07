import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';

class SplashScreen extends StatelessWidget {
  static SplashScreen builder(BuildContext context, GoRouterState state)
  => const SplashScreen();
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      context.push(RouteLocation.home);
    });

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Splash Screen"),
        ),
      ),
    );
  }
}