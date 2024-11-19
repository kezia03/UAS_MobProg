import 'package:flutter/material.dart';
import 'quiz_english.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class EnglishCoursePage extends StatefulWidget {
  @override
  _EnglishCoursePageState createState() => _EnglishCoursePageState();
}

class _EnglishCoursePageState extends State<EnglishCoursePage> {
  int currentIndex = 0;
  late PageController _pageController;

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Basic Vocabulary',
      'description': 'Build a strong foundation by learning essential vocabulary words that will help you understand basic ideas in your new language.',
      'icon': Icons.language,
    },
    {
      'title': 'Basic Grammar',
      'description': 'Understand fundamental grammar rules to form correct sentences.',
      'icon': Icons.edit_note,
    },
    {
      'title': 'Greetings & Introduction',
      'description': 'Learn essential phrases for greeting others and introducing yourself with confidence.',
      'icon': Icons.handshake,
    },
    {
      'title': 'Pronunciation Tips',
      'description': 'Get helpful tips to improve your pronunciation and sound more natural.',
      'icon': Icons.record_voice_over,
    },
    {
      'title': 'Quiz',
      'description': 'Lets put your knowledge to the test!',
      'icon': Icons.quiz,
    },
  ];

  late List<bool> checkedStatus;

  @override
  void initState() {
    super.initState();
    checkedStatus = List<bool>.filled(courses.length, false); // Semua checkbox awalnya tidak dicentang
    _pageController = PageController(viewportFraction: 0.8, initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void updateProgress(bool isChecked, int index) {
    setState(() {
      checkedStatus[index] = isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hitung progress berdasarkan jumlah checkbox yang dicentang
    final completedCourses = checkedStatus.where((status) => status).length;
    final progress = completedCourses / courses.length;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
          color: const Color(0xFF4B61DD), // Background biru
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris 1: Polylingo dan Ikon Favorit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Polylingo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Baris 2: Flag di kiri, lalu Arrow dan English di bawahnya
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flag di kiri
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/us_flag.png', // Path gambar bendera
                        height: 32,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Kembali ke halaman sebelumnya
                            },
                            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'English',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Baris 3: Lesson dan Quiz Info
              const Text(
                '4 Lessons   ·   1 Quiz',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
          // Body
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: courses.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Transform.scale(
                          scale: index == currentIndex ? 1 : 0.9,
                          child: CourseCard(
                            title: courses[index]['title']!,
                            description: courses[index]['description']!,
                            icon: courses[index]['icon'],
                            isChecked: checkedStatus[index],
                            onChecked: (value) {
                              updateProgress(value, index);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          '$completedCourses of ${courses.length} completed',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearPercentIndicator(
                          lineHeight: 8.0,
                          percent: progress,
                          backgroundColor: Colors.grey[300],
                          progressColor: const Color(0xFF4B61DD),
                          barRadius: const Radius.circular(8),
                        ),
                      ],
                    ),
                  ),
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      courses.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 10,
                        width: currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index ? const Color(0xFF4B61DD) : Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4B61DD),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isChecked;
  final Function(bool) onChecked;

  const CourseCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isChecked,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFA6C4E5), size: 100),
              const Spacer(),
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  onChecked(value ?? false);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFA6C4E5)),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (title == 'Quiz') {
                // Jika title adalah Quiz, arahkan ke QuizPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              } else {
                // Tambahkan logika untuk pelajaran lain jika diperlukan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Start $title')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Start',
              style: TextStyle(color: Color(0xFF4B5ECE)),
            ),
          ),
        ],
      ),
    );
  }
}