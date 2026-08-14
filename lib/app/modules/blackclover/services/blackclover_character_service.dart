import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/blackclover_character.dart';

class BlackcloverCharacterService {
  /// Loads every character from assets/data/characters/blackclover.json.
  static Future<List<BlackcloverCharacter>> loadCharacters() async {
    try {
      final raw = await rootBundle
          .loadString('assets/data/characters/blackclover.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) =>
              BlackcloverCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
