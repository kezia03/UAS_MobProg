import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:io'; // Untuk mendeteksi platform
import 'quiz_japanese.dart';

class JapaneseCoursePage extends StatefulWidget {
  @override
  _JapaneseCoursePageState createState() => _JapaneseCoursePageState();
}

class _JapaneseCoursePageState extends State<JapaneseCoursePage> {
  int currentIndex = 0;
  late PageController _pageController;

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Hiragana & Katakana',
      'description':
          'Learn the basic Japanese alphabets to start your journey.',
      'icon': Icons.book,
      'link': 'https://youtu.be/hQzRdI14Z8g'
    },
    {
      'title': 'Basic Greetings',
      'description': 'Learn essential phrases to greet and introduce yourself.',
      'icon': Icons.handshake,
      'link': 'https://youtu.be/ql2qtZZOxsQ'
    },
    {
      'title': 'Essential Grammar',
      'description': 'Understand the fundamental grammar rules of Japanese.',
      'icon': Icons.edit_note,
      'link': 'https://youtu.be/k5w-F64P8mI'
    },
    {
      'title': 'Pronunciation Tips',
      'description': 'Get tips to pronounce Japanese words correctly.',
      'icon': Icons.record_voice_over,
      'link': 'https://youtu.be/aHwvTpByJX8'
    },
    {
      'title': 'Quiz',
      'description': 'Let’s put your knowledge to the test!',
      'icon': Icons.quiz,
      'link': null
    },
  ];

  late List<bool> checkedStatus;

  @override
  void initState() {
    super.initState();
    checkedStatus = List<bool>.filled(courses.length, false);
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: currentIndex);
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

  Future<void> openURLForMobile(String url) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final Uri uri = Uri.parse(url);
        if (Platform.isAndroid) {
          await Process.run('am', [
            'start',
            '-a',
            'android.intent.action.VIEW',
            '-d',
            uri.toString()
          ]);
        } else if (Platform.isIOS) {
          await Process.run('open', [uri.toString()]);
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not open URL: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('This feature is only supported on mobile devices.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedCourses = checkedStatus.where((status) => status).length;
    final progress = completedCourses / courses.length;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFF4B61DD),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/jp_flag.png',
                          height: 32,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Japanese',
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
                            link: courses[index]['link'],
                            onQuizPressed: index == courses.length - 1
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QuizJapanesePage()),
                                    );
                                  }
                                : null,
                            onOpenURL: openURLForMobile,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
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
                          color: currentIndex == index
                              ? const Color(0xFF4B61DD)
                              : Colors.grey[300],
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
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
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
  final String? link;
  final Function(bool) onChecked;
  final VoidCallback? onQuizPressed;
  final Function(String) onOpenURL;

  const CourseCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isChecked,
    required this.onChecked,
    this.link,
    this.onQuizPressed,
    required this.onOpenURL,
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
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA6C4E5),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (link != null) {
                  onOpenURL(link!);
                } else if (onQuizPressed != null) {
                  onQuizPressed!();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'S t a r t',
                style: TextStyle(
                  color: Color(0xFF4B5ECE),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
