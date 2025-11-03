import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const CnrApp());
}

class CnrApp extends StatelessWidget {
  const CnrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CNR-App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainScreen(),
    );
  }
}
