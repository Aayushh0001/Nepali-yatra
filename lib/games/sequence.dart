import 'package:flutter/material.dart';
import 'game_services.dart'; // Assuming you have a GameServices package

class NumberSequenceGame extends StatefulWidget {
  const NumberSequenceGame({super.key});

  @override
  _NumberSequenceGameState createState() => _NumberSequenceGameState();
}

class _NumberSequenceGameState extends State<NumberSequenceGame> {
  int _currentNumber = 0;
  final List<String> _numbers = ['०','१','२','३','४','५','६','७','८','९'];
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade200, Colors.purple.shade200],
              ),
            ),
          ),

          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tap numbers in order!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 20,
                children: _numbers.map((numStr) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _numbers.indexOf(numStr) <= _currentNumber
                        ? Colors.green
                        : Colors.blue,
                    minimumSize: Size(60, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    if (_numbers.indexOf(numStr) == _currentNumber) {
                      setState(() {
                        _currentNumber++;
                        if (_currentNumber >= _numbers.length && !_isCompleted) {
                          _isCompleted = true;
                          GameServices.updateUserScore(10); // Update user score
                        }
                      });
                    }
                  },
                  child: Text(numStr, style: TextStyle(fontSize: 30, color: Colors.white)),
                )).toList(),
              ),
              SizedBox(height: 30),
              if (_isCompleted)
                AnimatedOpacity(
                  opacity: _isCompleted ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Text(
                    '🎉 Well Done!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
            ],
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
        ],
      ),
    );
  }
}