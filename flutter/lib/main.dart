import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BrixieApp());
}

class BrixieApp extends StatelessWidget {
  const BrixieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brixie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}