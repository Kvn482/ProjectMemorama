import 'package:flutter/material.dart';
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Juego de Memoria",
                style: TextStyle(
                  fontSize: 48.0,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(pairs: 8),
                        ),
                      );
                    },
                    child: const Text("Easy"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(pairs: 10),
                        ),
                      );
                    },
                    child: const Text("Medium"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(pairs: 12),
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
    );
  }
}
