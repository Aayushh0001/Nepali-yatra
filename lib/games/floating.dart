import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'game_services.dart';

class LetterTapGame extends StatefulWidget {
  @override
  _LetterTapGameState createState() => _LetterTapGameState();
}

class _LetterTapGameState extends State<LetterTapGame> {
  final AudioPlayer _audio = AudioPlayer();
  final List<String> _allLetters = [
    'अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ऋ', 'ए', 'ऐ', 'ओ', 'औ', 'अं', 'अः', // Nepali vowels
    '१', '२', '३', '४', '५', '६', '७', '८', '९', '०' // Nepali numerals
  ];
  late List<String> _letters; // Letters to display in the current game
  final Map<String, bool> _foundLetters = {};
  bool _isGameCompleted = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    // Randomly select 5 letters/numerals from the list
    final random = Random();
    _letters = List.from(_allLetters)..shuffle(random);
    _letters = _letters.take(5).toList(); // Display 5 random items

    // Reset found letters
    _foundLetters.clear();
    for (var letter in _letters) {
      _foundLetters[letter] = false;
    }
    _isGameCompleted = false;
  }

  void playSound(String fileName) async {
    await _audio.play(AssetSource('audio/$fileName'));
  }

  void checkGameCompletion() {
    if (_foundLetters.values.every((v) => v) && !_isGameCompleted) {
      setState(() {
        _isGameCompleted = true;
      });
      // Update user score in the leaderboard
      GameServices.updateUserScore(10);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have found all the letters/numerals!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _resetGame(); // Reset the game for a new round
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue[100]!, Colors.blue[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Exit button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, size: 30),
              color: Colors.red[700],
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Letters/Numerals
          for (var letter in _letters)
            if (!_foundLetters[letter]!)
              Positioned(
                left: Random().nextDouble() * MediaQuery.of(context).size.width,
                top: Random().nextDouble() * MediaQuery.of(context).size.height,
                child: GestureDetector(
                  onTap: () {
                    playSound('$letter.mp3');
                    setState(() => _foundLetters[letter] = true);
                    checkGameCompletion();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.orange[800],
                        fontFamily: 'Devangari',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

          // Progress
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                'Found: ${_foundLetters.values.where((v) => v).length}/${_letters.length}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}