import 'package:flutter/material.dart';
import 'numericals.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Games"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NepaliNumeralMatchGame(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4c8184),
                foregroundColor: Colors.black,
              ),
              child: const Text("Match the Numerals"),
            ),
          ],
        ),
      ),
    );
  }
}