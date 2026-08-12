import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/reborn_character.dart';

class RebornCharacterService {
  /// Loads every character from assets/data/characters/reborn.json.
  static Future<List<RebornCharacter>> loadCharacters() async {
    try {
      final raw = await rootBundle.loadString('assets/data/characters/reborn.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) => RebornCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
