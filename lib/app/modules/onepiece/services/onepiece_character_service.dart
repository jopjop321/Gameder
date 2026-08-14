import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/onepiece_character.dart';

class OnePieceCharacterService {
  /// Loads every character from assets/data/characters/onepiece.json.
  static Future<List<OnePieceCharacter>> loadCharacters() async {
    try {
      final raw =
          await rootBundle.loadString('assets/data/characters/onepiece.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) => OnePieceCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
