import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nepali_yatra/auth.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signout();
  }

  Widget _title(){
    return const Text('Nepali Yatra');
  }

   Widget _userUid(){
     return Text(user?.email ?? 'User email');
   }

   Widget _signOutButton(){
    return ElevatedButton(
      onPressed: signOut,
      child:const Text('Sign Out'),
    );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
