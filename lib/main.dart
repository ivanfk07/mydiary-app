import 'package:flutter/material.dart';
import 'package:my_diary/screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Diary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)
      ),
      home: const HomeScreen(),
    );
  }
}
