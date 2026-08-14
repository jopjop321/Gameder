import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/mha_character.dart';

class MhaCharacterService {
  /// Loads every character from assets/data/characters/mha.json.
  static Future<List<MhaCharacter>> loadCharacters() async {
    try {
      final raw = await rootBundle.loadString('assets/data/characters/mha.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) => MhaCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
