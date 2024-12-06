import 'package:flame/components.dart';

class Pipe extends SpriteComponent {
  static const double initialPipeSpeed = 150.0; // Velocidade constante
  static double pipeSpeed = initialPipeSpeed; // Velocidade constante
  static const double initialPipeSpacing = 200.0; // Distância entre os tubos
  static double pipeSpacing = initialPipeSpacing;

  late SpriteComponent bottomPipe; // Parte inferior do tubo
  bool hasPassed = false; // Indica se o pássaro já passou por este par de tubos

  Pipe(Sprite topSprite, Sprite bottomSprite, double screenWidth,
      double topHeight, double bottomHeight) {
    // Criando o tubo superior
    sprite = topSprite;
    size = Vector2(100, topHeight); // Tamanho do tubo superior
    position = Vector2(screenWidth, 0); // Posição do tubo superior

    // Criando o tubo inferior
    bottomPipe = SpriteComponent()
      ..sprite = bottomSprite
      ..size = Vector2(100, bottomHeight) // Tamanho do tubo inferior
      ..position = Vector2(
          screenWidth, topHeight + pipeSpacing); // Posição do tubo inferior
  }

  @override
  void onMount() {
    super.onMount();
    // Adicionando o tubo inferior ao jogo
    add(bottomPipe);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Movendo o par de tubos para a esquerda
    position.x -= pipeSpeed * dt;
    bottomPipe.position.x -= pipeSpeed * dt;

    // Remover tubos que saíram da tela
    if (position.x + width < 0) {
      removePipe();
    }
  }

  void removePipe() {
    removeFromParent(); // Remove o tubo superior
    bottomPipe.removeFromParent(); // Remove o tubo inferior
  }

  // Verifica colisão com o pássaro
  bool checkCollision(SpriteComponent bird) {
    // Verifica se o pássaro colide com os dois tubos (superior e inferior)
    return bird.toRect().overlaps(toRect()) ||
        bird.toRect().overlaps(bottomPipe.toRect());
  }
}
