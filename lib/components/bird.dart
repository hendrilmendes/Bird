import 'package:bird/components/pipe.dart';
import 'package:bird/game/bird_game.dart';
import 'package:flame/components.dart';

class Bird extends SpriteComponent with HasGameRef<BirdGame> {
  double velocityY = 0.0; // Velocidade vertical do pássaro
  final double gravity = 600.0; // Força da gravidade
  final double flapStrength = -200.0; // Força do flap (movimento para cima)
  final double maxFallSpeed = 400.0; // Limite da velocidade de queda para evitar quedas excessivas

  Bird(Sprite sprite, double x, double y)
      : super(sprite: sprite, position: Vector2(x, y), size: Vector2(50, 50));

  @override
  void update(double dt) {
    super.update(dt);

    // Aplica a gravidade, mas limita a velocidade de queda
    velocityY += gravity * dt;
    if (velocityY > maxFallSpeed) {
      velocityY = maxFallSpeed; // Limita a velocidade máxima de queda
    }

    // Atualiza a posição com a velocidade vertical
    position.y += velocityY * dt;

    // Limita a posição do pássaro para não sair da tela
    if (position.y > gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
      velocityY = 0; // Impede que o pássaro continue caindo
      gameOver(); // O jogo termina se o pássaro tocar no chão
    }

    // Adiciona um limite superior para o pássaro
    if (position.y < 0) {
      position.y = 0;
      velocityY = 0; // Impede que o pássaro ultrapasse o topo
    }

    // Verifica colisões com os tubos
    checkCollisions();
  }

  // Método para o pássaro bater as asas
  void flap() {
    velocityY = flapStrength; 
  }

  // Método para resetar a posição do pássaro
  void reset(Vector2 startPosition) {
    position = startPosition;
    velocityY = 0;
  }

  // Verifica colisões com os tubos
  void checkCollisions() {
    for (var pipe in gameRef.children.whereType<Pipe>()) {
      if (pipe.checkCollision(this)) {
        position.y = pipe.position.y + pipe.size.y; 
        velocityY = 0;
        gameOver(); 
      }
    }
  }

  // Função que finaliza o jogo
  void gameOver() {
    gameRef.gameOver();
  }
}
