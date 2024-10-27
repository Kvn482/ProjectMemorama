import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_memorama/src/components/info_card.dart';
import 'package:project_memorama/src/components/game_utils.dart';
import 'package:soundpool/soundpool.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Game _game = Game();

  // Estadísticas del juego
  int tries = 0;
  int score = 0;
  int secondsPassed = 0;
  Timer? _timer;
  bool isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    _game.initGame();
    _resetGameStats();

    // Inicia el temporizador para contar el tiempo
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsPassed++;
      });
    });
  }

  void _resetGameStats() {
    setState(() {
      tries = 0;
      score = 0;
      secondsPassed = 0;
      isButtonVisible = false;
    });
  }

  void checkWin() {
    // Detener el temporizador y mostrar el diálogo de victoria
    _timer?.cancel();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¡Has ganado!"),
        content: Text("Tiempo total: $secondsPassed segundos"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              startNewGame(); // Reinicia el juego si el usuario lo desea
            },
            child: const Text("Jugar de nuevo"),
          ),
        ],
      ),
    );
  }

  Future<void> _soundefect() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle.load("assets/sounds/cartoon_pop.flac").then((ByteData soundData) {
                  return pool.load(soundData);
                });
    int streamId = await pool.play(soundId);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego de Memoria - Tiempo: $secondsPassed s'),
        centerTitle: true,
        backgroundColor: Colors.orange[400],
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              info_card("Intentos", "$tries"),
              info_card("Puntuación", "$score"),
            ],
          ),
          SizedBox(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              itemCount: _game.gameImg!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tries++;
                      _game.gameImg![index] = _game.cards_list[index];
                      _game.matchCheck.add({index: _game.cards_list[index]});
                    });
                    if (_game.matchCheck.length == 2) {
                      if (_game.matchCheck[0].values.first ==
                          _game.matchCheck[1].values.first) {
                        score += 100;
                        _game.matchCheck.clear();
                        _soundefect();

                        if (score == 800) {
                          isButtonVisible = true;
                          checkWin();
                        }
                      } else {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            _game.gameImg![_game.matchCheck[0].keys.first] =
                                _game.hiddenCardpath;
                            _game.gameImg![_game.matchCheck[1].keys.first] =
                                _game.hiddenCardpath;
                            _game.matchCheck.clear();
                          });
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB46A),
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(_game.gameImg![index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Visibility(
            visible: isButtonVisible,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange[400],
              ),
              onPressed: startNewGame,
              child: const Text('Reiniciar'),
            ),
          ),
        ],
      ),
    );
  }
}
