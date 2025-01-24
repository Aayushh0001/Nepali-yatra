import 'package:flutter/material.dart';
import 'anthem.dart';

class NationalDetailsPage extends StatelessWidget {
  const NationalDetailsPage({super.key});

  Widget _buildDetailPage(String title, String content, String imagePath) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'National Anthem',
        'subtitle': 'राष्ट्र गान',
        'icon': Icons.music_note,
        'destination': const AnthemPage(),
      },
      {
        'title': 'National Bird',
        'subtitle': 'हिमालयन मोनाल',
        'icon': Icons.pets,
        'destination': _buildDetailPage(
          'Himalayan Monal',
          'The Himalayan Monal (Lophophorus impejanus) is the national bird of Nepal. Known for its iridescent plumage, it is found in the Himalayan forests.',
          'assets/images/national_bird.jpg',
        ),
      },
      {
        'title': 'National Animal',
        'subtitle': 'गाई',
        'icon': Icons.android,
        'destination': _buildDetailPage(
          'Cow',
          'The cow is sacred in Nepal and is considered the national animal. It symbolizes peace, prosperity, and national identity.',
          'assets/images/national_animal.jpg',
        ),
      },
      {
        'title': 'National Flower',
        'subtitle': 'लालीगुँराँस',
        'icon': Icons.local_florist,
        'destination': _buildDetailPage(
          'Rhododendron',
          'The Rhododendron (Lali Gurans) is the national flower of Nepal. It blooms in the Himalayan regions and represents the country\'s natural beauty.',
          'assets/images/national_flower.jpg',
        ),
      },
      {
        'title': 'Map of Nepal',
        'subtitle': 'देशको नक्शा',
        'icon': Icons.map,
        'destination': _buildDetailPage(
          'Map of Nepal',
          'Nepal is a landlocked country located in South Asia, between India and China, known for its mountainous terrain and diverse geography.',
          'assets/images/Map.jpg',
        ),
      },
      {
        'title': 'National Flag',
        'subtitle': 'नेपाली झण्डा',
        'icon': Icons.flag,
        'destination': _buildDetailPage(
          'National Flag of Nepal',
          'The only non-rectangular national flag in the world, featuring two triangular pennants with unique symbolism and cultural significance.',
          'assets/images/nepali_flag.jpg',
        ),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nepal'),
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(items[index]['icon'] as IconData),
            title: Text(items[index]['title'] as String),
            subtitle: Text(items[index]['subtitle'] as String),
            onTap: () {
              if (items[index].containsKey('destination')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => items[index]['destination'] as Widget),
                );
              }
            },
          );
        },
      ),
    );
  }
}