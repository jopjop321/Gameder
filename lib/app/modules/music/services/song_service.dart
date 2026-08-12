import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/song.dart';

class SongService {
  /// Loads songs for [collectionId] from assets/data/music/{file}.json.
  static Future<List<Song>> loadSongs(String collectionId) async {
    final songs = <Song>[];
    for (final file in resolveCollectionFiles(collectionId)) {
      try {
        final raw = await rootBundle.loadString('assets/data/music/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        songs.addAll(
          jsonList.map((item) => Song.fromJson(item as Map<String, dynamic>)),
        );
      } catch (_) {
        // Skip files that fail to load.
      }
    }
    return songs;
  }

  /// Only one data file currently exists ('all.json'), so this simply
  /// returns the requested collection id unconditionally.
  static List<String> resolveCollectionFiles(String collectionId) {
    return [collectionId];
  }
}
