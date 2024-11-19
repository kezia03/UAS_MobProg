import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0; // Indeks pertanyaan saat ini.
  int? _selectedIndex; // Indeks opsi yang dipilih untuk pertanyaan saat ini.
  int _score = 0; // Skor pengguna.
  bool _isSubmitted = false; // Apakah jawaban sudah dikirim.

  final List<Map<String, dynamic>> _questions = [
    {
      "question":
      "What is the correct word to complete the sentence? She ___ a book every day.",
      "options": ["Reads", "Read", "Reading", "To read"],
      "answer": 0, // Indeks jawaban benar (Reads).
    },
    {
      "question": "Which is the correct way to say the time? 7:30 AM",
      "options": [
        "Seven thirty",
        "Seven and a half",
        "Half past seven",
        "Seven o'clock"
      ],
      "answer": 2, // Indeks jawaban benar (Half past seven).
    },
    {
      "question": "What is the plural form of the word 'Child'?",
      "options": ["Childs", "Childes", "Children", "Childen"],
      "answer": 2, // Indeks jawaban benar (Children).
    },
    {
      "question": "What is the past tense of the verb 'Go'?",
      "options": ["Goed", "Went", "Goes", "Gone"],
      "answer": 1, // Indeks jawaban benar (Went).
    },
    {
      "question": "What is the correct article for the word 'Apple'?",
      "options": ["A", "An", "The", "No article"],
      "answer": 1, // Indeks jawaban benar (An).
    },
  ];

  void _submitAnswer(BuildContext context) {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an option before submitting.")),
      );
      return;
    }

    setState(() {
      _isSubmitted = true; // Tandai jawaban sebagai sudah dikirim.
      if (_selectedIndex == _questions[_currentQuestionIndex]["answer"]) {
        _score++; // Tambah skor jika jawaban benar.
      }
    });
  }

  void _nextQuestion(BuildContext context) {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedIndex = null; // Reset pilihan.
        _isSubmitted = false; // Reset status kirim.
      } else {
        _showFinalScore(context); // Tampilkan skor akhir.
      }
    });
  }

  void _showFinalScore(BuildContext context) {
    int totalScore = ((_score / _questions.length) * 100)
        .toInt(); // Hitung skor sebagai persentase.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz Completed!"),
          content: Text("Your score is $totalScore/100."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog.
                Navigator.pop(context); // Kembali ke halaman kursus.
              },
              child: Text("Back to Course"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion =
        _questions[_currentQuestionIndex]; // Pertanyaan saat ini.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF4A6DFF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz ${_currentQuestionIndex + 1} of ${_questions.length}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) /
                _questions.length, // Progress bar.
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A6DFF)),
          ),
          SizedBox(height: 32),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  currentQuestion["question"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: currentQuestion["options"].length,
              itemBuilder: (context, index) {
                return _buildOption(
                  currentQuestion["options"][index],
                  index,
                  currentQuestion["answer"],
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: !_isSubmitted
                    ? () => _submitAnswer(context)
                    : null, // Submit hanya jika belum dikirim.
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      !_isSubmitted ? Color(0xFF4A6DFF) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _isSubmitted
                    ? () => _nextQuestion(context)
                    : null, // Next hanya jika sudah dikirim.
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isSubmitted ? Color(0xFF4A6DFF) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    _currentQuestionIndex < _questions.length - 1
                        ? "Next"
                        : "Finish",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption(String text, int index, int correctAnswer) {
    Color getOptionColor() {
      if (!_isSubmitted) {
        // Highlight pilihan sementara.
        return _selectedIndex == index ? Colors.blue[100]! : Colors.grey[200]!;
      }
      if (index == correctAnswer)
        return Colors.green; // Highlight hijau untuk jawaban benar.
      if (index == _selectedIndex)
        return Colors.red; // Highlight merah untuk jawaban salah.
      return Colors.grey[200]!; // Default warna opsi lainnya.
    }

    return GestureDetector(
      onTap: () {
        if (!_isSubmitted) {
          setState(() {
            _selectedIndex = index; // Update pilihan pengguna.
          });
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: getOptionColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: (_isSubmitted || _selectedIndex == index)
                  ? Colors.white
                  : Colors.black, // Teks putih jika sudah dijawab atau dipilih.
            ),
          ),
        ),
      ),
    );
  }
}
