import 'package:flutter/material.dart';
import 'package:project_memorama/src/components/game_utils_hard.dart';
import 'package:project_memorama/src/components/info_card.dart';

class Gamehard extends StatefulWidget {
  const Gamehard({super.key});

  @override
  State<Gamehard> createState() => _GamehardState();
}

class _GamehardState extends State<Gamehard> {
  GameHard _game = GameHard();
  //game stats
  int tries = 0;
  int score = 0;

  bool isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _game.initGame();
  }

  void _resetGame() {
    setState(() {
      _game.initGame(); // Reinicia el estado del juego
      tries = 0; // Reinicia el contador de intentos
      score = 0; // Reinicia el puntaje
      isButtonVisible = false; // Oculta el botón de reinicio
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Memoria'),
        centerTitle: true,
        backgroundColor: Colors.orange[400],
        foregroundColor: Colors.white,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Center(
          //   child: Text('Memory Game'),
          // ),
          // const SizedBox(
          //   height: 24.0,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              info_card("Tries", "$tries"),
              info_card("Score", "$score"),
            ],
          ),
          SizedBox(
            height: 580,
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
                      //incrementing the clicks
                      tries++;
                      _game.gameImg![index] = _game.cards_list[index];
                      _game.matchCheck
                          .add({index: _game.cards_list[index]});
                    });
                    if (_game.matchCheck.length == 2) {
                      if (_game.matchCheck[0].values.first ==
                          _game.matchCheck[1].values.first) {
                        //incrementing the score
                        score += 100;
                        _game.matchCheck.clear();

                        if (score == 1200) {
                          isButtonVisible = true;
                        }
                      } else {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          // print(_game.gameColors);
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
              }
            ),
          ),
          const SizedBox(
             height: 30.0,
          ),
          Visibility(
            visible: isButtonVisible,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange[400]
              ),
              onPressed: _resetGame,
              child: const Text('Reiniciar'),
            ),
          ),
        ],
      ),
    );
  }
}