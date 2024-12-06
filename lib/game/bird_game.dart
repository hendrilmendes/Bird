import 'dart:math';
import 'package:bird/components/background.dart';
import 'package:bird/components/bird.dart';
import 'package:bird/components/ground.dart';
import 'package:bird/components/pipe.dart';
import 'package:bird/screen/game_over.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BirdGame extends FlameGame with TapDetector {
  late Bird bird;
  late Background background;
  late Ground ground;
  List<Pipe> pipes = [];
  Random random = Random();
  bool isInitialized = false;
  bool isGameOver = false;

  static const double pipeSpacing = 200;
  static const double pipeWidth = 80;
  static const double pipeHeightMin = 100;
  static const double pipeHeightMax = 300;
  static const double minPipeGap = 150;
  late Timer pipeTimer;

  double pipeSpeed = 150;
  double pipeGenerationInterval = 2.5;

  late GameOverScreen gameOverScreen;
  late TextComponent scoreText;
  late TextComponent highScoreText;

  int score = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Carrega o sprite do fundo
    Sprite backgroundSprite = await loadSprite('background_game.png');
    background = Background(backgroundSprite, size);
    add(background);

    // Carrega o sprite do chão
    Sprite groundSprite = await loadSprite('ground.png');
    ground = Ground(groundSprite, size.x, size.y - 50);
    add(ground);

    // Carrega o sprite do pássaro
    Sprite birdSprite = await loadSprite('bird.png');
    bird = Bird(birdSprite, 100, size.y / 2);
    add(bird);

    // Inicializa o pipeTimer com o intervalo de geração de tubos e define o método onTick
    pipeTimer = Timer(pipeGenerationInterval, onTick: spawnPipe, repeat: true);

    // Inicializa a tela de Game Over
    gameOverScreen = GameOverScreen(
      onRestart: resetGame,
    );

    // Inicializa o scoreText
    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(size.x - 200, 40),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
      anchor: Anchor.topLeft,
    );
    add(scoreText);

    // Recupera a pontuação mais alta
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int highScore = prefs.getInt('high_score') ?? 0;

    // Inicializa o highScoreText
    highScoreText = TextComponent(
      text: 'Record: $highScore',
      position: Vector2(size.x - 230, 80),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      anchor: Anchor.topLeft,
    );
    add(highScoreText);
  }

  void startGame() async {
    if (!isInitialized) {
      return;
    }

    pipes.clear();
    bird.reset(Vector2(100, size.y / 2));

    children.whereType<TextComponent>().forEach((component) {
      component.removeFromParent();
    });

    isGameOver = false;
    score = 0;
    updateScoreText();

    // Recupera a pontuação mais alta
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int highScore = prefs.getInt('high_score') ?? 0;
    if (kDebugMode) {
      print('Pontuação mais alta: $highScore');
    }

    pipeTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver) {
      return;
    }

    bird.update(dt);
    pipeTimer.update(dt);

    for (var pipe in pipes) {
      pipe.update(dt);

      // Verifica se o pássaro passou pelo par de tubos
      if (pipe.position.x + pipe.width < bird.position.x && !pipe.hasPassed) {
        pipe.hasPassed = true;
        score++;
        updateScoreText();
      }
    }

    pipes.removeWhere((pipe) => pipe.position.x + pipe.size.x < 0);

    // Verifica colisão
    for (var pipe in pipes) {
      if (bird.toRect().overlaps(pipe.toRect()) ||
          bird.toRect().overlaps(pipe.bottomPipe.toRect())) {
        gameOver();
      }
    }

    // Verifica se o pássaro caiu ou saiu da tela
    if (bird.position.y >= size.y - ground.height || bird.position.y <= 0) {
      gameOver();
    }
  }

  void updateScoreText() {
    scoreText.text = 'Score: $score';
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (isGameOver) {
      resetGame();
      return;
    }
    bird.flap();
  }

  Future<void> spawnPipe() async {
    if (pipes.length >= 10 || isGameOver) {
      return;
    }

    double topHeight =
        random.nextDouble() * (pipeHeightMax - pipeHeightMin) + pipeHeightMin;
    double bottomHeight = size.y - topHeight - pipeSpacing;

    if (bottomHeight < minPipeGap) {
      bottomHeight = minPipeGap;
      topHeight = size.y - bottomHeight - pipeSpacing;
    }

    final numberOfPipes = random.nextInt(3) + 1;

    for (int i = 0; i < numberOfPipes; i++) {
      final topPipe = Pipe(await loadSprite('pipe_up.png'),
          await loadSprite('pipe.png'), pipeWidth, topHeight, bottomHeight);
      final bottomPipe = Pipe(await loadSprite('pipe_up.png'),
          await loadSprite('pipe.png'), pipeWidth, topHeight, bottomHeight);

      double xPosition = size.x + i * (pipeWidth + 80);
      topPipe.position = Vector2(xPosition, 0);
      bottomPipe.position = Vector2(xPosition, 0);

      pipes.add(topPipe);
      pipes.add(bottomPipe);

      add(topPipe);
      add(bottomPipe);
    }
  }

  void gameOver() async {
    isGameOver = true;
    pipeTimer.stop();

    add(gameOverScreen);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int highScore = prefs.getInt('high_score') ?? 0;

    if (score > highScore) {
      await prefs.setInt('high_score', score);
    }
  }

  void resetGame() {
    pipes.clear();
    bird.reset(Vector2(100, size.y / 2));
    spawnPipe();
    pipeTimer.start();
    isGameOver = false;

    // Remove a tela de Game Over
    gameOverScreen.removeFromParent();
    score = 0;
    updateScoreText();
  }
}
