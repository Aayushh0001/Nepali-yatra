import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnthemPage extends StatefulWidget {
  const AnthemPage({super.key});

  @override
  State<AnthemPage> createState() => _AnthemPageState();
}

class _AnthemPageState extends State<AnthemPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose(){
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAnthem() async{
    if(_isPlaying){
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    }else{
      await _audioPlayer.play(
        AssetSource('audio/National_anthem.mp3'),
      );
      setState(() {
        _isPlaying = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('National Anthem'),
      ),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'National Anthem of Nepal',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'सयौं थुँगा फूलका हामी,\n एउटै माला नेपाली\nसार्वभौम भइ फैलिएका\nमेचि-माहाकाली\n\nप्रकृतिका कोटी-कोटी सम्पदाको आंचल\nवीरहरुका रगतले स्वतन्त्र र अटल\nज्ञानभूमि, शान्तिभूमि तराई, पहाड, हिमाल\nअखण्ड यो प्यारो हाम्रो मातृभूमि नेपाल\n\nबहुल जाति, भाषा, धर्म, संस्कृति छन् विशाल\nअग्रगामी राष्ट्र हाम्रो, जय जय नेपाल।',
            style: TextStyle(fontSize:18),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(onPressed: _playAnthem, child: Text(_isPlaying ? 'Pause Anthem':'Play Anthem')),
          )
        ],
      ),
      ),
    );
  }
}
