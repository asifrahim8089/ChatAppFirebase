import 'dart:async';

import 'package:chat_app/Screens/login_home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
      navigationPage,
    );
  }

  Future navigationPage() async {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 3),
        pageBuilder: (_, __, ___) => const LoginHome(),
      ),
    );
  }

  @override
  void initState() {
    startTime();
    // checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/images/login.jpg',
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
