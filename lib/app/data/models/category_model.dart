// category_model.dart
import 'package:flutter/material.dart';

class GameCategory {
  final String title;
  final String imagePath;
  final Color textColor;

  GameCategory({
    required this.title,
    required this.imagePath,
    required this.textColor,
  });
}

// ประกาศ List ข้อมูลไว้ท้ายไฟล์ หรือจะแยกไปดึงมาจาก Controller ก็ได้ครับ
final List<GameCategory> mockCategories = [
  GameCategory(title: 'Pokedle', imagePath: 'assets/images/pikachi.png', textColor: Colors.white),
  // GameCategory(title: 'ความรู้ทั่วไป', imagePath: 'assets/images/cat_knowledge.png', textColor: const Color(0xFFE5D85C)),
  // ... รายการอื่นๆ
];