import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/anime.dart';

class AnimeService {
  /// Loads anime for [difficultyId] from assets/data/anime/{file}.json.
  /// 'all' aggregates every difficulty file, mirroring Pokedle's 'all' gens.
  static Future<List<Anime>> loadAnimes(String difficultyId) async {
    final animes = <Anime>[];
    for (final file in resolveDifficultyFiles(difficultyId)) {
      try {
        final raw = await rootBundle.loadString('assets/data/anime/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        animes.addAll(
          jsonList.map((item) => Anime.fromJson(item as Map<String, dynamic>)),
        );
      } catch (_) {
        // Skip files that fail to load.
      }
    }
    return animes;
  }

  /// 'easy' -> ['easy'], ..., 'all' -> every difficulty file combined.
  static List<String> resolveDifficultyFiles(String difficultyId) {
    if (difficultyId == 'all') {
      return const ['easy', 'medium', 'hard'];
    }
    return [difficultyId];
  }
}
