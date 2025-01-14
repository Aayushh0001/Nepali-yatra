import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const NepaliYatra());

class NepaliYatra extends StatelessWidget {
  const NepaliYatra({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nepali Yatra"),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReadingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7c564f),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Reading Section"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DrawingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf6b7ae),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Writing Section"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading Section"),
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
                      builder: (context) =>
                          const LettersScreen(title: "Vowels")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7c564f),
                foregroundColor: Colors.black,
              ),
              child: const Text("Vowels"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LettersScreen(title: "Consonants")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9f849b),
                foregroundColor: Colors.black,
              ),
              child: const Text("Consonants"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LettersScreen(title: "Numerals")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4c8184),
                foregroundColor: Colors.black,
              ),
              child: const Text("Numerals"),
            ),
          ],
        ),
      ),
    );
  }
}
String getDescriptionForCharacter(String character){
  const descriptions ={
    //vowels
    'अ': 'a', 'आ': 'aa', 'इ': 'i', 'ई': 'ee', 'उ': 'u',
    'ऊ': 'uu', 'ऋ': 'ri', 'ए': 'e', 'ऐ': 'ai',
    'ओ': 'o', 'औ': 'au', 'अं': 'am', 'अः': 'ah',

    //consonants
    'क': 'ka', 'ख': 'kha', 'ग': 'ga', 'घ': 'gha', 'ङ': 'nga',
    'च': 'cha', 'छ': 'chha', 'ज': 'ja', 'झ': 'jha', 'ञ': 'nya',
    'ट': 'ṭa', 'ठ': 'ṭha', 'ड': 'ḍa', 'ढ': 'ḍha', 'ण': 'ṇa',
    'त': 'ta', 'थ': 'tha', 'द': 'da', 'ध': 'dha', 'न': 'na',
    'प': 'pa', 'फ': 'pha', 'ब': 'ba', 'भ': 'bha', 'म': 'ma',
    'य': 'ya', 'र': 'ra', 'ल': 'la', 'व': 'va',
    'श': 'sha', 'ष': 'ṣa', 'स': 'sa', 'ह': 'ha',
    'क्ष': 'kṣa', 'त्र': 'tra', 'ज्ञ': 'gya',

    //numerals
    '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
    '५': '5', '६': '6', '७': '7', '८': '8', '९': '9',
  };
  return descriptions[character] ?? 'unknown';
  }


class LettersScreen extends StatefulWidget {
  final String title;

  const LettersScreen({required this.title, super.key});

  @override
  _LettersScreenState createState() => _LettersScreenState();
}

class _LettersScreenState extends State<LettersScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void playsound(String fileName) async {
    await _audioPlayer.play(AssetSource('audio/$fileName'));
  }

  @override
  Widget build(BuildContext context) {
    final letters = getLettersForSection(widget.title);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(9.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: letters.length,
        itemBuilder: (context, index) {
          final character = letters[index];
          final description =getDescriptionForCharacter(character);
          return Card(
            color: Colors.lightBlue.shade50,
            child: InkWell(
              onTap: () {
                String soundFile = getAudioFileForCharacter(letters[index]);
                playsound(soundFile);
              },
              child: Center(
                child: Column(
                  children: [
                    Text(
                      character,
                      style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(description,
                    style: const TextStyle(fontSize: 16,color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> getLettersForSection(String section) {
    switch (section) {
      case "Vowels":
        return ["अ", "आ", "इ", "ई", "उ", "ऊ", "ऋ", "ए", "ऐ", "ओ", "औ"];
      case "Consonants":
        return [
          "क",
          "ख",
          "ग",
          "घ",
          "ङ",
          "च",
          "छ",
          "ज",
          "झ",
          "ञ",
          "ट",
          "ठ",
          "ड",
          "ढ",
          "ण",
          "त",
          "थ",
          "द",
          "ध",
          "न",
          "प",
          "फ",
          "ब",
          "भ",
          "म",
          "य",
          "र",
          "ल",
          "व",
          "श",
          "ष",
          "स",
          "ह",
          "क्ष",
          "त्र",
          "ज्ञ"
        ];
      case "Numerals":
        return ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"];
      default:
        return [];
    }
  }

  String getAudioFileForCharacter(String character){
    if (widget.title == "Vowels") {
      return 'Vowel_Audios/Vowel_${getIndexForVowel(character)}_$character.mp3';
    } else if (widget.title == "Consonants") {
      return 'Consonant_Audios/Consonant_${getIndexForConsonant(character)}_$character.mp3';
    } else if (widget.title == "Numerals") {
      return 'Numeral_Audios/Numeral_${getIndexForNumeral(character)}_$character.mp3';
    } else {
      return '';
    }
  }
  int getIndexForVowel(String vowel) {
    switch (vowel) {
      case 'अ': return 1;
      case 'आ': return 2;
      case 'इ': return 3;
      case 'ई': return 4;
      case 'उ': return 5;
      case 'ऊ': return 6;
      case 'ऋ': return 7;
      case 'ए': return 8;
      case 'ऐ': return 9;
      case 'ओ': return 10;
      case 'औ': return 11;
      case 'अं': return 12;
      case 'अः': return 13;
      default: return 0; //unknown vowels
    }
  }

  int getIndexForConsonant(String consonant) {
    switch (consonant) {
      case 'क': return 1;
      case 'ख': return 2;
      case 'ग': return 3;
      case 'घ': return 4;
      case 'ङ': return 5;
      case 'च': return 6;
      case 'छ': return 7;
      case 'ज': return 8;
      case 'झ': return 9;
      case 'ञ': return 10;
      case 'ट': return 11;
      case 'ठ': return 12;
      case 'ड': return 13;
      case 'ढ': return 14;
      case 'ण': return 15;
      case 'त': return 16;
      case 'थ': return 17;
      case 'द': return 18;
      case 'ध': return 19;
      case 'न': return 20;
      case 'प': return 21;
      case 'फ': return 22;
      case 'ब': return 23;
      case 'भ': return 24;
      case 'म': return 25;
      case 'य': return 26;
      case 'र': return 27;
      case 'ल': return 28;
      case 'व': return 29;
      case 'श': return 30;
      case 'ष': return 31;
      case 'स': return 32;
      case 'ह': return 33;
      case 'क्ष': return 34;
      case 'त्र': return 35;
      case 'ज्ञ': return 36;
      default: return 0; // unknown consonants
    }
  }

  int getIndexForNumeral(String numeral) {
    switch (numeral) {
      case '०': return 1;
      case '१': return 2;
      case '२': return 3;
      case '३': return 4;
      case '४': return 5;
      case '५': return 6;
      case '६': return 7;
      case '७': return 8;
      case '८': return 9;
      case '९': return 10;
      default: return 11; // unknown numerals
    }
  }

}

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Writing"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  _points.add(renderBox.globalToLocal(details.localPosition));
                });
              },
              onPanEnd: (details) => _points.add(Offset.zero),
              child: CustomPaint(
                painter: DrawingPainter(_points),
                size: Size.infinite,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _points.clear();
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text("Clear"),
              backgroundColor: const Color(0xFFf3b15a),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
