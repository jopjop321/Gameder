import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/bleach_character.dart';

class BleachCharacterService {
  /// Loads every character from assets/data/characters/bleach.json.
  static Future<List<BleachCharacter>> loadCharacters() async {
    try {
      final raw =
          await rootBundle.loadString('assets/data/characters/bleach.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((item) => BleachCharacter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
