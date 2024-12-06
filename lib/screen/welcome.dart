import 'package:bird/game/bird_game.dart';
import 'package:flame/game.dart'; // Importa o GameWidget do Flame
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final BirdGame game;

  const WelcomeScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Cor de fundo que remete ao céu
      body: Stack(
        children: [
          // Fundo do jogo (Exemplo de imagem de fundo)
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título do jogo com animação
                const AnimatedDefaultTextStyle(
                  duration: Duration(seconds: 1),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'PressStart2P',
                  ),
                  child: Text("Bem-vindo ao Bird!"),
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    game.startGame();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameWidget(game: game),
                      ),
                    );
                  },
                  child: const Text("Jogar",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    showSettings(context);
                  },
                  child: const Text("Ajustes",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    showCredits(context);
                  },
                  child: const Text("Créditos",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajustes"),
          content: const Text("Aqui vão as opções de ajustes."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  void showCredits(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Créditos"),
          content: const Text(
              "Desenvolvedor: Hendril\nJogo feito com Flame e Flutter"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}
