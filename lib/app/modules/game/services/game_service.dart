import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/video_game.dart';

class GameService {
  /// Loads games for [platformId] from assets/data/game/{file}.json.
  /// 'all' aggregates every platform file, mirroring Foodle's 'world'.
  static Future<List<VideoGame>> loadGames(String platformId) async {
    final games = <VideoGame>[];
    for (final file in resolvePlatformFiles(platformId)) {
      try {
        final raw = await rootBundle.loadString('assets/data/game/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        games.addAll(
          jsonList.map((item) => VideoGame.fromJson(item as Map<String, dynamic>)),
        );
      } catch (_) {
        // Skip files that fail to load.
      }
    }
    return games;
  }

  /// 'mobile' -> ['mobile'], ..., 'all' -> every platform file combined.
  static List<String> resolvePlatformFiles(String platformId) {
    if (platformId == 'all') {
      return const ['mobile', 'pc', 'nintendo', 'all'];
    }
    return [platformId];
  }
}
