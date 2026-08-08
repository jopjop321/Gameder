import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/food.dart';

class FoodService {
  /// Loads foods for [regionId] from assets/data/food/{file}.json.
  /// 'world' aggregates every category file, mirroring Pokedle's 'all' gens.
  static Future<List<Food>> loadFoods(String regionId) async {
    final foods = <Food>[];
    for (final file in resolveRegionFiles(regionId)) {
      try {
        final raw = await rootBundle.loadString('assets/data/food/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        foods.addAll(
          jsonList.map((item) => Food.fromJson(item as Map<String, dynamic>)),
        );
      } catch (_) {
        // Skip files that fail to load.
      }
    }
    return foods;
  }

  /// 'thai' -> ['thai'], ..., 'world' -> every category file combined.
  static List<String> resolveRegionFiles(String regionId) {
    if (regionId == 'world') {
      return const ['thai', 'japanese', 'chinese', 'european', 'world'];
    }
    return [regionId];
  }
}
