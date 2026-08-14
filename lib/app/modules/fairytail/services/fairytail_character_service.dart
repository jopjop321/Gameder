import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/fairytail_character.dart';

class FairytailCharacterService {
  /// Loads every character from assets/data/characters/fairytail.json.
  static Future<List<FairytailCharacter>> loadCharacters() async {
    try {
      final raw = await rootBundle
          .loadString('assets/data/characters/fairytail.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) =>
              FairytailCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
