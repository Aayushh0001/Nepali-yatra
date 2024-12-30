import 'package:flutter/material.dart';

void main() => runApp(const NepaliYatra());

class NepaliYatra extends StatelessWidget {
  const NepaliYatra({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LettersScreen(title: "Vowels")),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7c564f),  //background color
                  foregroundColor:Colors.black,          //Text color
              ),
              child:const Text("Vowels"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LettersScreen(title: "Consonants")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9f849b),
                foregroundColor: Colors.black,
              ),
              child: const Text("Consonants"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LettersScreen(title: "Numerals")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:Color(0xFF4c8184),
                foregroundColor:Colors.black,
              ),
              child: const Text("Numerals"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DrawingPage()),

                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFf6b7ae),
                foregroundColor: Colors.black,
              ),
              child: const Text("Writing Section"),
            ),
          ],
        ),
      ),
    );
  }
}

class LettersScreen extends StatelessWidget {
  final String title;

  const LettersScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final letters = getLettersForSection(title);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
          return Card(
            color: Colors.lightBlue.shade50,
            child: Center(
              child: Text(
                letters[index],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
          "क", "ख", "ग", "घ", "ङ",
          "च", "छ", "ज", "झ", "ञ",
          "ट", "ठ", "ड", "ढ", "ण",
          "त", "थ", "द", "ध", "न",
          "प", "फ", "ब", "भ", "म",
          "य", "र", "ल", "व", "श", "ष", "स", "ह", "क्ष", "त्र", "ज्ञ"
        ];
      case "Numerals":
        return ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"];
      default:
        return [];
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
              backgroundColor: Color(0xFFf3b15a),
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
