import 'package:flutter/material.dart';
import 'package:project_memorama/src/components/game_utils_mid.dart';
import 'package:project_memorama/src/components/info_card.dart';

class Gamemid extends StatefulWidget {
  const Gamemid({super.key});

  @override
  State<Gamemid> createState() => _GamemidState();
}

class _GamemidState extends State<Gamemid> {
  GameMid _game_mid = GameMid();
  //game stats
  int tries = 0;
  int score = 0;

  bool isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _game_mid.initGame();
  }

  void _resetGame() {
    setState(() {
      _game_mid.initGame(); // Reinicia el estado del juego
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(
             height: 60.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              itemCount: _game_mid.gameImg!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
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
                      _game_mid.gameImg![index] = _game_mid.cards_list[index];
                      _game_mid.matchCheck
                          .add({index: _game_mid.cards_list[index]});
                    });
                    if (_game_mid.matchCheck.length == 2) {
                      if (_game_mid.matchCheck[0].values.first ==
                          _game_mid.matchCheck[1].values.first) {
                        //incrementing the score
                        score += 100;
                        _game_mid.matchCheck.clear();

                        if (score == 1000) {
                          isButtonVisible = true;
                        }
                      } else {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          // print(_game_mid.gameColors);
                          setState(() {
                            _game_mid.gameImg![_game_mid.matchCheck[0].keys.first] =
                                _game_mid.hiddenCardpath;
                            _game_mid.gameImg![_game_mid.matchCheck[1].keys.first] =
                                _game_mid.hiddenCardpath;
                            _game_mid.matchCheck.clear();
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
                        image: AssetImage(_game_mid.gameImg![index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
            ),
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