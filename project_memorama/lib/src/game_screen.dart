import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final int pairs;
  const GameScreen({super.key, required this.pairs});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          
        ),
      ),
    );
  }
}