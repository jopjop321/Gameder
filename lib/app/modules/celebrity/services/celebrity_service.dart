import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/celebrity.dart';

class CelebrityService {
  /// Loads celebrities for [collectionId] from assets/data/celebrity/{file}.json.
  /// 'all' aggregates every category file, mirroring Foodle's 'world'.
  static Future<List<Celebrity>> loadCelebrities(String collectionId) async {
    final celebrities = <Celebrity>[];
    for (final file in resolveCollectionFiles(collectionId)) {
      try {
        final raw =
            await rootBundle.loadString('assets/data/celebrity/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        celebrities.addAll(
          jsonList.map(
            (item) => Celebrity.fromJson(item as Map<String, dynamic>),
          ),
        );
      } catch (_) {
        // Skip files that fail to load.
      }
    }
    return celebrities;
  }

  /// 'youtuber' -> ['youtuber'], ..., 'all' -> every category file combined.
  static List<String> resolveCollectionFiles(String collectionId) {
    if (collectionId == 'all') {
      return const [
        'youtuber',
        'global_youtuber',
        'actor',
        'singer',
        'athlete',
        'kpop_idol',
        'y_series_actor',
        'korean_actor',
      ];
    }
    return [collectionId];
  }
}
