import 'package:flutter/material.dart';
import 'package:project_memorama/src/gameHard.dart';
import 'package:project_memorama/src/gameMid.dart';
import 'package:project_memorama/src/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Juego de Memoria',
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/menu_background.jpeg"),
                  fit: BoxFit.cover,
                )
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Juego de Memoria",
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Builder( // Aquí se asegura de que el contexto tenga acceso al Navigator
                    builder: (context) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            backgroundColor: Colors.orange[400],
                            foregroundColor: Colors.red[600],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GameScreen(),
                              ),
                            );
                          },
                          child: const Text("Easy"),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            backgroundColor: Colors.orange[400],
                            foregroundColor: Colors.red[600],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Gamemid(),
                              ),
                            );
                          },
                          child: const Text("Medium"),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            backgroundColor: Colors.orange[400],
                            foregroundColor: Colors.red[600],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Gamehard(),
                              ),
                            );
                          },
                          child: const Text("Hard"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
