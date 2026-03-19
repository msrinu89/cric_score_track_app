import 'package:flutter/material.dart';
import 'screens/start_match_screen.dart';

void main() {
  runApp(CricketApp());
}

class CricketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartMatchScreen(),
    );
  }
}