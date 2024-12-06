import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends PositionComponent with TapCallbacks {
  final VoidCallback onRestart;

  GameOverScreen({required this.onRestart});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Desenha o fundo transparente
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black.withOpacity(0.6),
    ));

    add(
      TextComponent(
        text: 'GAME OVER',
        position: size / 2 - Vector2(0, 50),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
        anchor: Anchor.center,
      ),
    );

    add(
      TextComponent(
        text: 'Toque para Reiniciar',
        position: size / 2 + Vector2(0, 30),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onRestart();
  }
}
