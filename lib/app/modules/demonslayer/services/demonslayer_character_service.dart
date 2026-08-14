import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/demonslayer_character.dart';

class DemonslayerCharacterService {
  /// Loads every character from assets/data/characters/demonslayer.json.
  static Future<List<DemonslayerCharacter>> loadCharacters() async {
    try {
      final raw = await rootBundle
          .loadString('assets/data/characters/demonslayer.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) =>
              DemonslayerCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
