import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/aot_character.dart';

class AotCharacterService {
  /// Loads every character from assets/data/characters/aot.json.
  static Future<List<AotCharacter>> loadCharacters() async {
    try {
      final raw = await rootBundle.loadString('assets/data/characters/aot.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) => AotCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
