import 'package:flutter/material.dart';
import 'numericals.dart';
import 'sequence.dart' as sequence;
import 'floating.dart';


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
            // Existing numeral match game
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
                minimumSize: const Size(200, 50),
              ),
              child: const Text("Match the Numerals"),
            ),
            const SizedBox(height: 20),

            // Floating letters game
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LetterTapGame(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 50),
              ),
              child: const Text("Floating Letters"),
            ),
            const SizedBox(height: 20),

            // Number sequence game
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => sequence.NumberSequenceGame(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[300],
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 50),
              ),
              child: const Text("Number Sequence"),
            ),
          ],
        ),
      ),
    );
  }
}