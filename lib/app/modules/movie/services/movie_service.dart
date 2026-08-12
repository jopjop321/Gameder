import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/movie.dart';

class MovieService {
  /// Loads movies for [collectionId] from assets/data/movies/{file}.json.
  static Future<List<Movie>> loadMovies(String collectionId) async {
    final movies = <Movie>[];
    for (final file in resolveCollectionFiles(collectionId)) {
      try {
        final raw = await rootBundle.loadString('assets/data/movies/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        movies.addAll(
          jsonList.map((item) => Movie.fromJson(item as Map<String, dynamic>)),
        );
      } catch (_) {
        // Skip files that fail to load.
      }
    }
    return movies;
  }

  /// There is currently only one data file, so this just returns [collectionId].
  static List<String> resolveCollectionFiles(String collectionId) {
    return [collectionId];
  }
}
