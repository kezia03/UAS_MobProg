import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/english_course_page.dart';
import 'screens/japanese_course_page.dart';
import 'screens/spanish_course_page.dart';

void main() {
  runApp(const PolylingoApp());
}

class PolylingoApp extends StatelessWidget {
  const PolylingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polylingo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4B61DD),
        scaffoldBackgroundColor: const Color(0xFF4B61DD),
      ),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/english_course': (context) => EnglishCoursePage(),
        '/japanese_course': (context) => JapaneseCoursePage(),
        '/spanish_course': (context) => SpanishCoursePage(),
      },
    );
  }
}
