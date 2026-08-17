import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/food.dart';

class FoodService {
  /// Thai sub-region ids -> the `region_en` value to filter thai.json by.
  static const Map<String, String> thaiRegionFilters = {
    'thai_central': 'Central Region',
    'thai_northeast': 'Northeastern Region (Isan)',
    'thai_north': 'Northern Region',
    'thai_south': 'Southern Region',
  };

  /// Loads foods for [regionId] from assets/data/food/{file}.json.
  /// 'world' aggregates every category file, mirroring Pokedle's 'all' gens.
  /// Thai sub-regions (e.g. 'thai_north') load thai.json then filter by region.
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

    final regionFilter = thaiRegionFilters[regionId];
    if (regionFilter == null) return foods;
    return foods.where((food) => food.regionEn == regionFilter).toList();
  }

  /// 'thai' -> ['thai'], 'thai_north'/etc -> ['thai'] (filtered after load),
  /// 'world' -> every category file combined.
  static List<String> resolveRegionFiles(String regionId) {
    if (regionId == 'world') {
      return const ['thai', 'japanese', 'chinese', 'european', 'world'];
    }
    if (thaiRegionFilters.containsKey(regionId)) {
      return const ['thai'];
    }
    return [regionId];
  }
}
