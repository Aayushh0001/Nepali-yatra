import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nepali_yatra/Screens/home_page.dart';
import 'package:nepali_yatra/Screens/login_register_page.dart';
import 'package:nepali_yatra/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return HomePage();
          }else{
            return const LoginPage();
          }
        });
  }
}
