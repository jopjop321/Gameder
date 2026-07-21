import 'package:flutter/material.dart';

class GameCategory {
  final String title;
  final String imagePath;
  final Color textColor;
  final String gameType; // เพิ่มตัวนี้: ระบุว่าการ์ดนี้คือเกมอะไร
  final String? genFile; // เพิ่มตัวนี้: เฉพาะ Pokedle ใช้ระบุ 'gen1', 'gen2', 'all'

  GameCategory({
    required this.title,
    required this.imagePath,
    required this.textColor,
    required this.gameType,
    this.genFile,
  });
}

final List<GameCategory> mockCategories = [
  GameCategory(
    title: 'Pokedle',
    imagePath: 'assets/images/pikachi.png',
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen1',
  ),
  // GameCategory(title: 'ความรู้ทั่วไป', ... gameType: 'trivia'),
];