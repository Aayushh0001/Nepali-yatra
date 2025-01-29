import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nepali_yatra/Screens/home_page.dart';
import 'package:nepali_yatra/Screens/login_register_page.dart';
import 'package:nepali_yatra/auth.dart';
import 'package:nepali_yatra/main.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges, // Listen to Firebase Auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return HomePage();
        } else {
          // User is not logged in, show LoginPage
          return const LoginPage();
        }
      },
    );
  }
}