import 'package:flame/components.dart';

class Ground extends SpriteComponent {
  final double screenHeight;
  final double screenWidth;

  Ground(Sprite sprite, this.screenWidth, this.screenHeight)
      : super(sprite: sprite, size: Vector2(screenWidth, 100)) {
    // Inicializa a posição do chão na parte inferior da tela
    position = Vector2(0, screenHeight - 100);
  }
}
