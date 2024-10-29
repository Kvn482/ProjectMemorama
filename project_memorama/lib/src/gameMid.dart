import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_memorama/src/components/info_card.dart';
import 'package:project_memorama/src/components/game_utils_mid.dart';
import 'package:soundpool/soundpool.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Gamemid extends StatefulWidget {
  const Gamemid({super.key});

  @override
  State<Gamemid> createState() => _GamemidState();
}

class _GamemidState extends State<Gamemid> {
  GameMid _game = GameMid();
  Soundpool pool = Soundpool(streamType: StreamType.notification);

  String popSound  = "assets/sounds/cartoon_pop.flac";
  String dandan = "assets/sounds/dandan.WAV";

  // Estadísticas del juego
  int tries = 0;
  int score = 0;
  int secondsPassed = 0;
  int? highScore = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  Future<Database> getDatabase() async {
  // Define el path de la base de datos
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'scores.db'); // Nombre de la base de datos

    // Abre la base de datos, creando una nueva si no existe
    return await openDatabase(
      path,
      version: 1, // Versión de la base de datos
      onCreate: (Database db, int version) async {
        // Crear la tabla 'scores' si no existe
        await db.execute(
          'CREATE TABLE scores (id INTEGER PRIMARY KEY AUTOINCREMENT, score INTEGER)',
        );
      },
    );
  }

  Future<void> insertScore(int score) async {
    final db = await getDatabase();

    // Insertar el puntaje en la tabla 'scores'
    await db.insert(
      'scores',                 // Nombre de la tabla
      {'score': score},         // Valor a insertar
      conflictAlgorithm: ConflictAlgorithm.replace, // En caso de conflicto, reemplaza el registro
    );
  }

  Future<int?> getHighestScore() async {
    final db = await getDatabase();

    // Ejecutamos una consulta para obtener el puntaje más alto
    final List<Map<String, dynamic>> result = await db.query(
      'scores',                 // Nombre de la tabla
      columns: ['score'],       // La columna de puntajes
      orderBy: 'score ASC',    // Ordenar de mayor a menor
      limit: 1,                 // Limitar el resultado a uno solo
    );

    // Verificamos si se obtuvo algún resultado
    if (result.isNotEmpty) {
      return result.first['score'] as int?;
    }
    return null;  // Si no hay datos
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
    });
  }

  void checkWin(BuildContext context) async {
    // Detener el temporizador y mostrar el diálogo de victoria
    _timer?.cancel();
    _soundefect(dandan);

    // Insertar el puntaje del tiempo transcurrido
    await insertScore(secondsPassed);

    // Obtener el puntaje más alto de forma asíncrona
    highScore = await getHighestScore();
    

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

  Future<void> _soundefect(String sound) async {
    int soundId = await rootBundle.load(sound).then((ByteData soundData) {
      return pool.load(soundData);
    });
    print(soundId);
    // Reproduce el sonido y espera hasta que finalice
    await pool.play(soundId);  // `await` para esperar que termine
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
              info_card("HighScore", "$highScore"),
            ],
          ),
          SizedBox(
            height: 550,
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
                        _soundefect(popSound);

                        if (score == 1000) {
                          checkWin(context);
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
        ],
      ),
    );
  }
}
