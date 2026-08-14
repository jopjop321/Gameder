import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/hxh_character.dart';

class HxhCharacterService {
  /// Loads every character from assets/data/characters/hxh.json.
  static Future<List<HxhCharacter>> loadCharacters() async {
    try {
      final raw =
          await rootBundle.loadString('assets/data/characters/hxh.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) => HxhCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
