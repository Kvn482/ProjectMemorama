import 'package:flutter/material.dart';

class Game {
  final Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;

  final String hiddenCardpath = "assets/img/Logo_Turtle.jpeg";
  List<String> cards_list = [
    "assets/img/FutureGohan.jpeg",
    "assets/img/FutureTrunks.jpeg",
    "assets/img/GohanSJJ.jpeg",
    "assets/img/GokuSJJ.jpeg",
    "assets/img/Krillin.jpeg",
    "assets/img/MajinVegeta.jpeg",
    "assets/img/MasterRoshi.jpeg",
    "assets/img/Piccolo.jpeg",
    "assets/img/FutureGohan.jpeg", // Duplicado para pares
    "assets/img/FutureTrunks.jpeg",
    "assets/img/GohanSJJ.jpeg",
    "assets/img/GokuSJJ.jpeg",
    "assets/img/Krillin.jpeg",
    "assets/img/MajinVegeta.jpeg",
    "assets/img/MasterRoshi.jpeg",
    "assets/img/Piccolo.jpeg",

  ];
  final int cardCount = 16;
  List<Map<int, String>> matchCheck = [];

  //methods
  void initGame() {
    cards_list.shuffle(); // Aquí mezclamos las cartas
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}
