import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/brand.dart';

class BrandService {
  /// Loads brands for [collectionId] from assets/data/brands/{file}.json.
  static Future<List<Brand>> loadBrands(String collectionId) async {
    final brands = <Brand>[];
    for (final file in resolveCollectionFiles(collectionId)) {
      try {
        final raw = await rootBundle.loadString('assets/data/brands/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        brands.addAll(
          jsonList.map((item) => Brand.fromJson(item as Map<String, dynamic>)),
        );
      } catch (_) {
        // Skip files that fail to load.
      }
    }
    return brands;
  }

  /// Only one data file currently exists ('all'), so every collection id
  /// maps directly to its own file.
  static List<String> resolveCollectionFiles(String collectionId) {
    return [collectionId];
  }
}
