import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../controllers/pokemon.dart';

class PokedexService {
  /// Loads Pokémon from asset JSON file(s). Returns empty list on failure.
  static Future<List<Pokemon>> loadPokedex(String genFile) async {
    final files = resolveGenFiles(genFile);
    final Map<int, Pokemon> byId = {};

    for (final file in files) {
      try {
        final raw = await rootBundle.loadString('assets/data/pokedle/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        for (final item in jsonList) {
          final p = Pokemon.fromJson(item as Map<String, dynamic>);
          byId[p.id] = p;
        }
      } catch (_) {
        // Skip gen files that don't exist as assets (relevant for 'all').
      }
    }

    final pokedex = byId.values.toList()..sort((a, b) => a.id.compareTo(b.id));
    return pokedex;
  }

  /// 'gen1' -> ['gen1'], 'gen2' -> ['gen2'], 'all' -> every known gen file.
  static List<String> resolveGenFiles(String genFile) {
    if (genFile == 'all') {
      return List.generate(9, (i) => 'gen${i + 1}');
    }
    return [genFile];
  }
}
