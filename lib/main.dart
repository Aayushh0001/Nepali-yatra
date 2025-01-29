import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nepali_yatra/features/quiz_feature.dart';
import 'package:nepali_yatra/features/time.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nepali_yatra/games/games.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widget_tree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NepaliYatra());
}

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
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(
            child: Center(
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
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder:(context)=>const GamesScreen()
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C8184),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Games")
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const QuizFeature()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9f849b),
                    foregroundColor: Colors.black,
                  ),
                      child: const Text("Quiz & Visualiztion"),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      default: return 0;
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
      default: return 0;
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
      default: return 11;
    }
  }

}

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final List<Offset?> _points = [];
  final List<List<Offset?>> _undoStack = [];
  final List<List<Offset?>> _redoStack = [];
  String? _selectedCategory;
  String? _selectedLetter;
  Color _brushColor = Colors.black;
  double _brushSize = 4.0;

  final Map<String, Map<String, String>> _categories = {
    "Vowels": {
      "अ": "assets/stroke_orders/vowels/a.png",
      "आ": "assets/stroke_orders/vowels/aa.png",
      "इ": "assets/stroke_orders/vowels/i.png",
      "ई": "assets/stroke_orders/vowels/ee.png",
      "उ": "assets/stroke_orders/vowels/u.png",
      "ऊ": "assets/stroke_orders/vowels/uu.png",
      "ऋ": "assets/stroke_orders/vowels/rri.png",
      "ए": "assets/stroke_orders/vowels/e.png",
      "ऐ": "assets/stroke_orders/vowels/ai.png",
      "ओ": "assets/stroke_orders/vowels/o.png",
      "औ": "assets/stroke_orders/vowels/au.png",
    },
    "Consonants": {
      "क": "assets/stroke_orders/consonants/ka.png",
      "ख": "assets/stroke_orders/consonants/kha.png",
      "ग": "assets/stroke_orders/consonants/ga.png",
      "घ": "assets/stroke_orders/consonants/gha.png",
      "ङ": "assets/stroke_orders/consonants/nga.png",
      "च": "assets/stroke_orders/consonants/cha.png",
      "छ": "assets/stroke_orders/consonants/chha.png",
      "ज": "assets/stroke_orders/consonants/ja.png",
      "झ": "assets/stroke_orders/consonants/jha.png",
      "ञ": "assets/stroke_orders/consonants/nya.png",
      "ट": "assets/stroke_orders/consonants/ṭa.png",
      "ठ": "assets/stroke_orders/consonants/tha.png",
      "ड": "assets/stroke_orders/consonants/da.png",
      "ढ": "assets/stroke_orders/consonants/ḍha.png",
      "ण": "assets/stroke_orders/consonants/na.png",
      "त": "assets/stroke_orders/consonants/ta.png",
      "थ": "assets/stroke_orders/consonants/ƫha.png",
      "द": "assets/stroke_orders/consonants/daa.png",
      "ध": "assets/stroke_orders/consonants/dha.png",
      "न": "assets/stroke_orders/consonants/ńa.png",
      "प": "assets/stroke_orders/consonants/pa.png",
      "फ": "assets/stroke_orders/consonants/pha.png",
      "ब": "assets/stroke_orders/consonants/ba.png",
      "भ": "assets/stroke_orders/consonants/bha.png",
      "म": "assets/stroke_orders/consonants/ma.png",
      "य": "assets/stroke_orders/consonants/ya.png",
      "र": "assets/stroke_orders/consonants/ra.png",
      "ल": "assets/stroke_orders/consonants/la.png",
      "व": "assets/stroke_orders/consonants/va.png",
      "श": "assets/stroke_orders/consonants/sha.png",
      "ष": "assets/stroke_orders/consonants/ṣa.png",
      "स": "assets/stroke_orders/consonants/sa.png",
      "ह": "assets/stroke_orders/consonants/ha.png",
      "क्ष": "assets/stroke_orders/consonants/ksa.png",
      "त्र": "assets/stroke_orders/consonants/tra.PNG",
      "ज्ञ": "assets/stroke_orders/consonants/gya.png"
    },
    "Numerals": {
      "०": "assets/stroke_orders/numerals/0.png",
      "१": "assets/stroke_orders/numerals/1.png",
      "२": "assets/stroke_orders/numerals/2.png",
      "३": "assets/stroke_orders/numerals/3.png",
      "४": "assets/stroke_orders/numerals/4.png",
      "५": "assets/stroke_orders/numerals/5.png",
      "६": "assets/stroke_orders/numerals/6.png",
      "७": "assets/stroke_orders/numerals/7.png",
      "८": "assets/stroke_orders/numerals/8.png",
      "९": "assets/stroke_orders/numerals/9.png"
    },
  };

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick Brush Color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _brushColor,
            onColorChanged: (color) {
              setState(() {
                _brushColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _undo() {
    if (_points.isNotEmpty) {
      setState(() {
        _redoStack.add(List.from(_points));
        _points.clear();
        if (_undoStack.isNotEmpty) {
          _points.addAll(_undoStack.removeLast());
        }
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _undoStack.add(List.from(_points));
        _points.clear();
        _points.addAll(_redoStack.removeLast());
      });
    }
  }

  void _clear() {
    setState(() {
      _undoStack.add(List.from(_points));
      _points.clear();
    });
  }

  void _goBackToCategories() {
    setState(() {
      _selectedLetter = null;
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Writing Section"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _goBackToCategories(); // Reset when going back
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Category selection
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: _categories.keys.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      _selectedLetter = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedCategory == category
                          ? Colors.blue.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedCategory == category
                            ? Colors.blue
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Letter selection
          if (_selectedCategory != null)
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: _categories[_selectedCategory]!.keys.map((letter) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLetter = letter;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedLetter == letter
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedLetter == letter
                              ? Colors.blue
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          // Stroke Order Display
          if (_selectedLetter != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                _categories[_selectedCategory]![_selectedLetter] ??
                    "assets/stroke_orders/default.png",
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
          // Drawing Area
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  _points.add(renderBox.globalToLocal(details.localPosition));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _points.add(null);
                });
              },
              child: Container(
                color: Colors.grey.shade200,
                child: CustomPaint(
                  painter: DrawingPainter(_points, _brushColor, _brushSize),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          // Brush options and controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: _undo,
                  icon: const Icon(Icons.undo),
                ),
                IconButton(
                  onPressed: _redo,
                  icon: const Icon(Icons.redo),
                ),
                IconButton(
                  onPressed: _clear,
                  icon: const Icon(Icons.clear),
                ),
                IconButton(
                  onPressed: _pickColor,
                  icon: const Icon(Icons.color_lens),
                ),
                SizedBox(
                  width: 100,
                  child: Slider(
                    value: _brushSize,
                    min: 1.0,
                    max: 20.0,
                    onChanged: (size) {
                      setState(() {
                        _brushSize = size;
                      });
                    },
                    label: 'Brush Size',
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


class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color brushColor;
  final double brushSize;

  DrawingPainter(this.points, this.brushColor, this.brushSize);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = brushColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawCircle(points[i]!, brushSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



