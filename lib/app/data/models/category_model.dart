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
    gameType: 'pokedle_menu',
    genFile: 'pokedle_menu',
  ),
  // GameCategory(title: 'ความรู้ทั่วไป', ... gameType: 'trivia'),
];

// ข้อมูลหมวดหมู่ย่อย สำหรับหน้า Pokedle โดยเฉพาะ
final List<GameCategory> pokedleCategories = [
  GameCategory(
    title: 'Gen 1-9 (ทุกหมวด)',
    imagePath: 'assets/images/pikachi.png', // เปลี่ยนชื่อรูปตามที่คุณมี
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'all', // คีย์เวิร์ดสำหรับดึงทุกไฟล์
  ),
  GameCategory(
    title: 'Generation 1',
    imagePath: 'assets/images/pikachi.png', // ใช้รูปของ Gen 1
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen1',
  ),
  GameCategory(
    title: 'Generation 2',
    imagePath: 'assets/images/pikachi.png', // เปลี่ยนชื่อรูป
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen2',
  ),
  GameCategory(
    title: 'Generation 3',
    imagePath: 'assets/images/pikachi.png', // เปลี่ยนชื่อรูป
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen3',
  ),
  GameCategory(
    title: 'Generation 4',
    imagePath: 'assets/images/pikachi.png', // ใช้รูปของ Gen 1
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen4',
  ),
  GameCategory(
    title: 'Generation 5',
    imagePath: 'assets/images/pikachi.png', // เปลี่ยนชื่อรูป
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen5',
  ),
  GameCategory(
    title: 'Generation 6',
    imagePath: 'assets/images/pikachi.png', // เปลี่ยนชื่อรูป
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen6',
  ),
  GameCategory(
    title: 'Generation 7',
    imagePath: 'assets/images/pikachi.png', // ใช้รูปของ Gen 1
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen7',
  ),
  GameCategory(
    title: 'Generation 8',
    imagePath: 'assets/images/pikachi.png', // เปลี่ยนชื่อรูป
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen8',
  ),
  GameCategory(
    title: 'Generation 9',
    imagePath: 'assets/images/pikachi.png', // เปลี่ยนชื่อรูป
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'gen9',
  ),
];