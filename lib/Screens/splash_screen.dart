// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:chat_app/Screens/chat_list.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Screens/login_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('email') && prefs.containsKey('password')) {
      // Register the onMessageOpenedApp callback function
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Navigate to the chat screen and pass the notification message as a parameter
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatScreen(notificationmessage: message.notification?.body),
          ),
        );
      });
      // The shared preferences are present, so the user is logged in.
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(seconds: 3),
          pageBuilder: (_, __, ___) => const ChatList(),
        ),
      );
    } else {
      // The shared preferences are not present, so the user is not logged in.

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(seconds: 3),
          pageBuilder: (_, __, ___) => const LoginHome(),
        ),
      );
    }
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
