import 'package:bird/game/bird_game.dart';
import 'package:bird/screen/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final birdGame = BirdGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(game: birdGame),
    );
  }
}
