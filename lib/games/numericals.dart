import 'package:flutter/material.dart';
import 'dart:math';

class NepaliNumeralMatchGame extends StatefulWidget {
  const NepaliNumeralMatchGame({super.key});

  @override
  _NepaliNumeralMatchGameState createState() => _NepaliNumeralMatchGameState();
}

class _NepaliNumeralMatchGameState extends State<NepaliNumeralMatchGame> {
  final List<Map<String, String>> numerals = [
    {'nepali': '०', 'english': '0'},
    {'nepali': '१', 'english': '1'},
    {'nepali': '२', 'english': '2'},
    {'nepali': '३', 'english': '3'},
    {'nepali': '४', 'english': '4'},
    {'nepali': '५', 'english': '5'},
    {'nepali': '६', 'english': '6'},
    {'nepali': '७', 'english': '7'},
    {'nepali': '८', 'english': '8'},
    {'nepali': '९', 'english': '9'},
  ];

  late List<Map<String, String>> shuffledNepaliNumerals;
  late List<Map<String, String>> shuffledEnglishNumerals;

  Map<String, String>? selectedNepaliNumeral;
  Map<String, String>? selectedEnglishNumeral;

  final List<String> matchedPairs = [];

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    final random = Random();
    final selectedNumerals = List<Map<String, String>>.from(numerals)..shuffle(random);
    final fiveNumerals = selectedNumerals.take(5).toList();

    shuffledNepaliNumerals = List.from(fiveNumerals);
    shuffledEnglishNumerals = List.from(fiveNumerals);

    shuffledNepaliNumerals.shuffle(random);
    shuffledEnglishNumerals.shuffle(random);

    selectedNepaliNumeral = null;
    selectedEnglishNumeral = null;
    matchedPairs.clear();
  }

  void selectNumeral(Map<String, String> numeral, bool isNepali) {
    setState(() {
      if (isNepali) {
        selectedNepaliNumeral = numeral;
      } else {
        selectedEnglishNumeral = numeral;
      }

      if (selectedNepaliNumeral != null && selectedEnglishNumeral != null) {
        if (selectedNepaliNumeral!['english'] == selectedEnglishNumeral!['english']) {

          matchedPairs.add(selectedNepaliNumeral!['english']!);


          shuffledNepaliNumerals.remove(selectedNepaliNumeral);
          shuffledEnglishNumerals.remove(selectedEnglishNumeral);

          selectedNepaliNumeral = null;
          selectedEnglishNumeral = null;
          if (matchedPairs.length == 5) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Congratulations!'),
                content: Text('You matched all numerals correctly!'),
                actions: [
                  TextButton(
                    child: Text('Play Again'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        resetGame();
                      });
                    },
                  ),
                  TextButton(
                    child: Text('Exit'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
        } else {
          // Not matched, reset selection
          selectedNepaliNumeral = null;
          selectedEnglishNumeral = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nepali Numeral Matching Game')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nepali Numerals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                // Add SingleChildScrollView to avoid overflow
                SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: shuffledNepaliNumerals.map((numeral) {
                      return GestureDetector(
                        onTap: () => selectNumeral(numeral, true),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: selectedNepaliNumeral == numeral
                                ? Colors.yellow
                                : (matchedPairs.contains(numeral['english']) ? Colors.green : Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              numeral['nepali']!,
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('English Numerals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: shuffledEnglishNumerals.map((numeral) {
                      return GestureDetector(
                        onTap: () => selectNumeral(numeral, false),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: selectedEnglishNumeral == numeral
                                ? Colors.yellow
                                : (matchedPairs.contains(numeral['english']) ? Colors.green : Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              numeral['english']!,
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
