import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/naruto_character.dart';

class NarutoCharacterService {
  /// Loads every character from assets/data/characters/naruto.json.
  static Future<List<NarutoCharacter>> loadCharacters() async {
    try {
      final raw =
          await rootBundle.loadString('assets/data/characters/naruto.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) => NarutoCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
