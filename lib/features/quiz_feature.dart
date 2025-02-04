import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer audioPlayer = AudioPlayer();
final List<Map<String ,String>> animals = [
  {'english': 'Tiger','nepali':'बाघ','image':'assets/animals/tiger.jpeg'},
  {'english': 'Cat','nepali':'बिरालो','image':'assets/animals/cat.jpeg'},
  {'english': 'Elephant','nepali':'हात्ती','image':'assets/animals/elephant.jpeg'},
  {'english': 'Giraffe','nepali':'जिराफ','image':'assets/animals/giraffe.jpeg'},
  {'english': 'Squirrel','nepali':'गिलहरी','image':'assets/animals/squirrel.jpeg'},
  {'english': 'Horse','nepali':'घोडा','image':'assets/animals/horse.jpeg'},
];

final List<Map<String ,String>> flowers = [
  {'english': 'Rose', 'nepali': 'गुलाब', 'image': 'assets/flowers/rose.jpg'},
  {'english': 'Lotus', 'nepali': 'कमल', 'image': 'assets/flowers/lotus.jpg'},
  {'english': 'Rhododendron', 'nepali': 'लालीगुराँस', 'image': 'assets/flowers/rhododendron.jpg'},
  {'english': 'Daisy', 'nepali': 'लालीगुराँस', 'image': 'assets/flowers/daisy.jpeg'},
  {'english': 'Marigold', 'nepali': 'सयपत्री', 'image': 'assets/flowers/marigold.jpg'},
  {'english': 'Sunflower', 'nepali': 'सूर्यमुखी', 'image': 'assets/flowers/sunflowers.jpeg'},
  {'english': 'Tulips', 'nepali': 'ट्युलिप्स', 'image': 'assets/flowers/tulips.jpeg'},
];

final List<Map<String, String>> colors = [
  {'english': 'Red', 'nepali': 'रातो', 'image': 'assets/colors/red.jpg'},
  {'english': 'Green', 'nepali': 'हरियो', 'image': 'assets/colors/download.png'},
  {'english': 'Blue', 'nepali': 'निलो', 'image': 'assets/colors/blue.png'},
  {'english': 'Pink', 'nepali': 'गुलाबी', 'image': 'assets/colors/pink.png'},
  {'english': 'Black', 'nepali': 'कालो', 'image': 'assets/colors/black.png'},
  {'english': 'White', 'nepali': 'सेतो', 'image': 'assets/colors/white.jpg'},
];

final List<Map<String, dynamic>> categories = [
  {
    'title': 'Animals',
    'image': 'assets/animals/tiger.jpeg',
    'data': animals,
    'color': Colors.orange,
  },
  {
    'title': 'Colors',
    'image': 'assets/colors/red.jpg',
    'data': colors,
    'color': Colors.red,
  },
  {
    'title': 'Flowers',
    'image': 'assets/flowers/rose.jpg',
    'data': flowers,
    'color': Colors.pink,
  },
  {
    'title': 'Quiz',
    'image': 'assets/quiz.png',
    'color': Colors.blue,
  },
];

class QuizFeature extends StatelessWidget {
  const QuizFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn & Play'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => category['title'] == 'Quiz'
                  ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()))
                  : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisualizationScreen(
                    data: category['data'],
                    title: category['title'],
                    categoryColor: category['color'],
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: category['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      category['image'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: category['color'],
                      ),
                    ),
                    if (category['title'] == 'Quiz')
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Icon(Icons.quiz, color: Colors.blue),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VisualizationScreen extends StatelessWidget {
  final List<Map<String, String>> data;
  final String title;
  final Color categoryColor;

  const VisualizationScreen({
    super.key,
    required this.data,
    required this.title,
    required this.categoryColor,
  });

  // Function that plays animal sound

  void _playAnimalSound(String animalName) async {
    try {
      await audioPlayer.play(AssetSource('Sounds/$animalName.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn $title',
            style: TextStyle(color: categoryColor)),
        centerTitle: true,
        backgroundColor: categoryColor.withOpacity(0.1),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                if (title == 'Animals') {
                  _playAnimalSound(item['english']!.toLowerCase()); // Play sound for animals
                }
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(item['image']!),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          item['english']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                        Text(
                          item['nepali']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Map<String, dynamic>> quizData;
  int currentQuestionIndex = 0;
  int score = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    quizData = _generateQuizData();
  }

  List<Map<String, dynamic>> _generateQuizData() {
    final combinedList = [
      ...animals.map((e) => {'type': 'animal', ...e}),
      ...flowers.map((e) => {'type': 'flower', ...e}),
      ...colors.map((e) => {'type': 'color', ...e}),
    ];

    final List<Map<String, dynamic>> generatedData = [];

    for (int i = 0; i < 10; i++) {
      final category = ['animal', 'flower', 'color'][_random.nextInt(3)];
      final categoryItems =
      combinedList.where((item) => item['type'] == category).toList();
      final correctItem = categoryItems[_random.nextInt(categoryItems.length)];

      final wrongItems = categoryItems
          .where((item) => item['english'] != correctItem['english'])
          .toList()
        ..shuffle();

      final options = [
        correctItem['nepali'],
        ...wrongItems.take(3).map((e) => e['nepali'])
      ]..shuffle();

      generatedData.add({
        'question': 'What ${category == 'color' ? 'color' : category} is this?',
        'nepaliQuestion': _getNepaliQuestion(category),
        'image': correctItem['image'],
        'answer': correctItem['nepali'],
        'options': options,
        'categoryColor': _getCategoryColor(category),
      });
    }

    return generatedData;
  }

  String _getNepaliQuestion(String category) {
    switch (category) {
      case 'animal':
        return 'यो चित्रमा कुन जनावर छ?';
      case 'flower':
        return 'यो चित्रमा कुन फूल छ?';
      case 'color':
        return 'यो चित्रमा कुन रङ छ?';
      default:
        return 'यो चित्र के हो?';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'animal':
        return Colors.orange;
      case 'flower':
        return Colors.pink;
      case 'color':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == quizData[currentQuestionIndex]['answer']) {
      setState(() => score++);
    }

    if (currentQuestionIndex < quizData.length - 1) {
      setState(() => currentQuestionIndex++);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Complete!',
              style: TextStyle(color: Colors.green)),
          content: Text('Your score: $score/${quizData.length}',
              style: const TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentQuestionIndex = 0;
                  score = 0;
                  quizData = _generateQuizData();
                });
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = quizData[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Time!'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                currentQuestion['categoryColor'].withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / quizData.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      currentQuestion['categoryColor']),
                ),
                const SizedBox(height: 20),
                Text(
                  'Question ${currentQuestionIndex + 1} of ${quizData.length}',
                  style: TextStyle(
                    fontSize: 16,
                    color: currentQuestion['categoryColor'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          currentQuestion['nepaliQuestion'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              currentQuestion['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: (currentQuestion['options'] as List)
                              .map<Widget>((option) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor:
                                currentQuestion['categoryColor'],
                                minimumSize: const Size(double.infinity,
                                    50),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  side: BorderSide(
                                    color:
                                    currentQuestion['categoryColor'],
                                  ),
                                ),
                              ),
                              onPressed: () => checkAnswer(option),
                              child: Text(
                                option,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}