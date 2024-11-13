import 'package:flutter/material.dart';

class EnglishCoursePage extends StatefulWidget {
  @override
  _EnglishCoursePageState createState() => _EnglishCoursePageState();
}

class _EnglishCoursePageState extends State<EnglishCoursePage> {
  int currentIndex = 0;
  int progress = 0;

  final List<Map<String, String>> courses = [
    {
      'title': 'Basic Vocabulary',
      'description': 'Build a strong foundation by learning essential vocabulary words that will help you understand basic ideas in your new language.'
    },
    {
      'title': 'Greetings & Introduction',
      'description': 'Learn essential phrases for greeting others and introducing yourself with confidence.'
    },
    {
      'title': 'Everyday Conversations',
      'description': 'Get comfortable with daily conversations by learning common phrases and expressions.'
    },
    {
      'title': 'Grammar Basics',
      'description': 'Understand the basics of grammar rules that will support your language learning journey.'
    },
    {
      'title': 'Advanced Vocabulary',
      'description': 'Expand your vocabulary with more advanced words and expressions.'
    },
  ];

  void updateProgress(bool isChecked) {
    setState(() {
      if (isChecked) {
        progress = (progress + 1).clamp(0, courses.length);
      } else {
        progress = (progress - 1).clamp(0, courses.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        title: const Text('Polylingo', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset('assets/us_flag.png', height: 32), 
                const SizedBox(width: 8),
                const Text(
                  'English',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Spacer(),
                const Text(
                  '4 Lessons   |   1 Quiz',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                itemCount: courses.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return CourseCard(
                    title: courses[index]['title']!,
                    description: courses[index]['description']!,
                    onChecked: updateProgress,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('${currentIndex + 1} of ${courses.length}'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LinearProgressIndicator(
                value: progress / courses.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4B61DD)),
              ),
            ),
          ],
        ),
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

class CourseCard extends StatefulWidget {
  final String title;
  final String description;
  final Function(bool) onChecked;

  CourseCard({required this.title, required this.description, required this.onChecked});

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey[300]!)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: Color(0xFF4B61DD), size: 40),
              const Spacer(),
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value ?? false;
                    widget.onChecked(isChecked);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4B61DD)),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Start',
              style: TextStyle(color: Color(0xFF4B61DD)),
            ),
          ),
        ],
      ),
    );
  }
}
