import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nepali_yatra/features/quiz_feature.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nepali_yatra/games/games.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imgs;
import 'dart:ui' as ui;
import 'Screens/login_signup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NepaliYatra());
}

class NepaliYatra extends StatelessWidget {
  const NepaliYatra({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Start with Home in the middle

  // List of screens to display
  final List<Widget> _screens = [
    const LeaderboardScreen(), // Index 0
    const MainContentScreen(), // Index 1 (Home)
    const ProfileScreen(),     // Index 2
  ];

  // Handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 1
            ? const Text("Nepali Yatra")
            : const SizedBox.shrink(),
        actions: [
          if (_selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
            ),
        ],
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class MainContentScreen extends StatelessWidget {
  const MainContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Nepali Yatra',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start your journey to learn Nepali',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grid of Features
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    'Reading Section',
                    'Learn Nepali characters',
                    Icons.menu_book,
                    const Color(0xFF7c564f),
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReadingScreen()),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Writing Section',
                    'Practice writing',
                    Icons.edit,
                    const Color(0xFFf6b7ae),
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrawingPage()),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Games',
                    'Learn through Games',
                    Icons.games,
                    const Color(0xFF4C8184),
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GamesScreen()),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Quiz & Visualization',
                    'Test your knowledge',
                    Icons.quiz,
                    const Color(0xFF9f849b),
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizFeature()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text('No user data found. Please update your profile.'),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final createdAt = (userData['createdAt'] as Timestamp).toDate();

        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header with Background
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue.shade300,
                      Colors.blue.shade600,
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Large Profile Picture with Default
                    Positioned(
                      top: 30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: userData['photoUrl'] != null
                              ? Image.network(
                            userData['photoUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultAvatar(userData['name']),
                          )
                              : _buildDefaultAvatar(userData['name']),
                        ),
                      ),
                    ),
                    // Name
                    Positioned(
                      bottom: 20,
                      child: Text(
                        userData['name'] ?? 'Anonymous',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Information Cards
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Stats Row
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('Score', '${userData['score'] ?? 0}'),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          _buildStatColumn(
                            'Member Since',
                            '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.email, 'Email', user?.email ?? 'N/A'),
                          const Divider(height: 20),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Joined',
                            '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultAvatar(String? name) {
    return Container(
      color: Colors.blue.shade100,
      child: Center(
        child: Text(
          (name?.isNotEmpty == true) ? name![0].toUpperCase() : 'A',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade400, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade50, Colors.white],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Top Players',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index].data() as Map<String, dynamic>;
                      final rank = index + 1;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: _getRankColor(rank),
                                backgroundImage: user['photoUrl'] != null
                                    ? NetworkImage(user['photoUrl'])
                                    : null,
                                child: user['photoUrl'] == null
                                    ? Text(
                                  (user['name'] ?? 'A')[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : null,
                              ),
                              if (rank <= 3)
                                Positioned(
                                  bottom: -2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getRankColor(rank),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '#$rank',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            user['name'] ?? 'Anonymous',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            user['email'] ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getScoreColor(user['score'] ?? 0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '${user['score'] ?? 0} pts',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.blueGrey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue.shade400;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 1000) return Colors.purple;
    if (score >= 500) return Colors.indigo;
    if (score >= 250) return Colors.blue;
    return Colors.teal;
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  String? _photoUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'] ?? '';
          _photoUrl = doc['photoUrl'];
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      setState(() => _isLoading = true);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'photoUrl': _photoUrl,
      });

      setState(() => _isLoading = false);
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  Future<void> _uploadPhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      setState(() => _isLoading = true);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_photos/${user.uid}.jpg');

      await storageRef.putFile(File(pickedFile.path));
      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        _photoUrl = downloadUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading photo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 47,
                            backgroundImage: _photoUrl != null
                                ? NetworkImage(_photoUrl!)
                                : null,
                            child: _photoUrl == null
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _uploadPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.save),
                                SizedBox(width: 8),
                                Text('Save Changes'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Email: ${user?.email ?? 'Not logged in'}'),
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
  Interpreter? _interpreter;
  bool _iscorrect = false;
  bool _hasChecked = false;

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

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/nepali_char.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> checkDrawing() async {
    try {
      // 1. Convert drawing to image
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // White background
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = Colors.white);

      // Draw user's strokes
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = _brushSize
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < _points.length - 1; i++) {
        if (_points[i] != null && _points[i + 1] != null) {
          canvas.drawLine(_points[i]!, _points[i + 1]!, paint);
        }
      }

      // 2. Convert to 28x28 grayscale image
      final picture = recorder.endRecording();
      final uiImage = await picture.toImage(28, 28);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      final image = imgs.decodeImage(byteData!.buffer.asUint8List())!;
      final grayscale = imgs.grayscale(image);  // Official grayscale conversion

      // 3. Prepare model input tensor
      final input = List.generate(1, (_) =>
          List.generate(28, (_) =>
              List.generate(28, (_) =>
                  List.filled(1, 0.0))));

      // 4. Normalize pixel values properly
      for (int y = 0; y < 28; y++) {
        for (int x = 0; x < 28; x++) {
          final pixel = grayscale.getPixel(x, y);
          // Get luminance value (proper grayscale conversion)
          final value = imgs.getLuminance(pixel) / 255.0;
          input[0][y][x][0] = value;
        }
      }

      // 5. Run inference
      final output = List.filled(1 * 58, 0.0).reshape([1, 58]);
      _interpreter!.run(input, output);

      // ... rest of your processing logic ...
    } catch (e) {
      print('Error in checkDrawing: $e');
    }
  }

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
      _hasChecked = false;
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
            _goBackToCategories();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
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
            child: Stack(
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      _points.add(renderBox.globalToLocal(details.localPosition));
                      _hasChecked = false;  // Reset check status when drawing
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
                // Add prediction feedback overlay
                if (_hasChecked)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _iscorrect ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _iscorrect ? 'Correct!' : 'Try Again',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
                // Add Check button
                ElevatedButton(
                  onPressed: _selectedLetter != null ? checkDrawing : null,
                  child: const Text('Check'),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
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



