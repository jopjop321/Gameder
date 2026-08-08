import 'package:flutter/material.dart';

class GameCategory {
  final String title;
  final String? imagePath;
  final IconData? icon;
  final Color textColor;
  final String gameType;

  /// Pokedle only: 'gen1', 'gen2', ..., or 'all'.
  final String? genFile;
  final String? gameId;

  const GameCategory({
    required this.title,
    required this.textColor,
    required this.gameType,
    this.imagePath,
    this.icon,
    this.genFile,
    this.gameId,
  }) : assert(imagePath != null || icon != null);
}

final List<GameCategory> mockCategories = [
  GameCategory(
    title: 'Pokedle',
    imagePath: 'assets/images/pikachi.png',
    textColor: Colors.black,
    gameType: 'pokedle_menu',
    genFile: 'pokedle_menu',
  ),
  GameCategory(
    title: 'อาหารนี้คืออะไร?',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_menu',
  ),
  // GameCategory(title: 'ความรู้ทั่วไป', ... gameType: 'trivia'),
];

/// Sub-categories for the Pokedle selection screen.
final List<GameCategory> pokedleCategories = [
  const GameCategory(
    title: 'Gen 1-9 (ทุกหมวด)',
    imagePath: 'assets/images/pikachi.png',
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'all',
  ),
  ...List.generate(
    9,
    (i) => GameCategory(
      title: 'Generation ${i + 1}',
      imagePath: 'assets/images/pikachi.png',
      textColor: Colors.black,
      gameType: 'pokedle',
      genFile: 'gen${i + 1}',
    ),
  ),
];

final List<GameCategory> foodCategories = [
  const GameCategory(
    title: 'อาหารไทย',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'thai',
  ),
  const GameCategory(
    title: 'อาหารญี่ปุ่น',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'japanese',
  ),
  const GameCategory(
    title: 'อาหารจีน',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'chinese',
  ),
  const GameCategory(
    title: 'อาหารยุโรป',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'european',
  ),
  const GameCategory(
    title: 'อาหารทั่วโลก',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'world',
  ),
];
